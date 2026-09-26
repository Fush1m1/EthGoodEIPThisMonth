// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MLDSA} from "../src/eip8355/MLDSA.sol";
import {MLDSAAccount} from "../src/eip8355/MLDSAAccount.sol";

/// @dev Mock of the EIP-8355 precompile. Instead of real ML-DSA verification, a signature is
///      treated as valid if its first 32 bytes == keccak256(pubkey ++ message).
///      The I/O format (concatenated input, 32-byte output, 0 for short input) follows EIP-8355.
///      EIP-8355 プリコンパイルのモック。実際の ML-DSA 検証の代わりに
///      「署名の先頭 32 バイト == keccak256(pubkey ++ message)」なら有効とみなす。
///      入出力フォーマット（連結入力・32 バイト出力・短い入力は 0）は EIP-8355 に合わせる。
contract MockMLDSAPrecompile {
    uint256 private immutable pkLen;
    uint256 private immutable sigLen;

    constructor(uint256 pkLen_, uint256 sigLen_) {
        pkLen = pkLen_;
        sigLen = sigLen_;
    }

    fallback(bytes calldata input) external returns (bytes memory) {
        if (input.length < pkLen + sigLen) return abi.encode(uint256(0));
        bytes32 expected = keccak256(abi.encodePacked(input[:pkLen], input[pkLen + sigLen:]));
        return abi.encode(bytes32(input[pkLen:pkLen + 32]) == expected ? uint256(1) : uint256(0));
    }
}

contract LibHarness {
    function verify(MLDSA.ParamSet ps, bytes memory pk, bytes memory sig, bytes memory message)
        external
        view
        returns (bool)
    {
        return MLDSA.verify(ps, pk, sig, message);
    }

    function isAvailable(MLDSA.ParamSet ps) external view returns (bool) {
        return MLDSA.isAvailable(ps);
    }
}

contract Target {
    uint256 public value;

    function set(uint256 v) external payable {
        value = v;
    }
}

contract MLDSATest is Test {
    LibHarness internal lib;

    function setUp() public {
        lib = new LibHarness();
    }

    function _installPrecompile() internal {
        vm.etch(address(0x12), address(new MockMLDSAPrecompile(1312, 2420)).code);
    }

    function _key(uint8 seed) internal pure returns (bytes memory pk) {
        pk = new bytes(1312);
        for (uint256 i; i < pk.length; i += 32) {
            pk[i] = bytes1(seed);
        }
    }

    function _sign(bytes memory pk, bytes memory message) internal pure returns (bytes memory sig) {
        sig = new bytes(2420);
        bytes32 tag = keccak256(abi.encodePacked(pk, message));
        for (uint256 i; i < 32; ++i) {
            sig[i] = tag[i];
        }
    }

    function test_NotAvailableBeforeFork() public view {
        // Without the precompile, empty returndata comes back -> treated as false
        // プリコンパイル未導入のチェーンでは空の returndata が返る → false 扱い
        assertFalse(lib.isAvailable(MLDSA.ParamSet.MLDSA44), "should be unavailable");
        bytes memory pk = _key(1);
        assertFalse(lib.verify(MLDSA.ParamSet.MLDSA44, pk, _sign(pk, "hi"), "hi"), "must not verify");
    }

    function test_VerifyValidAndInvalid() public {
        _installPrecompile();
        assertTrue(lib.isAvailable(MLDSA.ParamSet.MLDSA44), "should be available");
        bytes memory pk = _key(1);
        bytes memory sig = _sign(pk, "hello");
        assertTrue(lib.verify(MLDSA.ParamSet.MLDSA44, pk, sig, "hello"), "valid signature rejected");
        assertFalse(lib.verify(MLDSA.ParamSet.MLDSA44, pk, sig, "hellO"), "tampered message accepted");
        assertFalse(lib.verify(MLDSA.ParamSet.MLDSA44, _key(2), sig, "hello"), "wrong key accepted");
    }

    function test_RevertOnBadLength() public {
        vm.expectRevert(abi.encodeWithSelector(MLDSA.InvalidSignatureLength.selector, 2420, 10));
        lib.verify(MLDSA.ParamSet.MLDSA44, _key(1), new bytes(10), "");
    }

    function test_VerifyGas() public pure {
        assertEq(MLDSA.verifyGas(MLDSA.ParamSet.MLDSA44, 0), 6500, "44 base");
        assertEq(MLDSA.verifyGas(MLDSA.ParamSet.MLDSA65, 33), 9012, "65 two words");
        assertEq(MLDSA.verifyGas(MLDSA.ParamSet.MLDSA87, 32), 13506, "87 one word");
    }

    function test_AccountExecute() public {
        _installPrecompile();
        bytes memory pk = _key(7);
        MLDSAAccount account = new MLDSAAccount(MLDSA.ParamSet.MLDSA44, pk);
        vm.deal(address(account), 1 ether);
        Target target = new Target();

        bytes memory data = abi.encodeCall(Target.set, (42));
        bytes memory sig = _sign(pk, account.operationMessage(address(target), 0.1 ether, data, 0));
        account.execute(address(target), 0.1 ether, data, pk, sig);

        assertEq(target.value(), 42, "call not executed");
        assertEq(address(target).balance, 0.1 ether, "value not sent");
        assertEq(account.nonce(), 1, "nonce not bumped");

        // Reusing the same signature (replay) fails because the nonce has advanced
        // 同じ署名の再利用（リプレイ）は nonce が進んでいるので失敗する
        vm.expectRevert(MLDSAAccount.InvalidSignature.selector);
        account.execute(address(target), 0.1 ether, data, pk, sig);
    }

    function test_AccountRejectsUnknownKey() public {
        _installPrecompile();
        MLDSAAccount account = new MLDSAAccount(MLDSA.ParamSet.MLDSA44, _key(7));
        bytes memory other = _key(8);
        bytes memory sig = _sign(other, account.operationMessage(address(0), 0, "", 0));
        vm.expectRevert(MLDSAAccount.UnknownPublicKey.selector);
        account.execute(address(0), 0, "", other, sig);
    }
}
