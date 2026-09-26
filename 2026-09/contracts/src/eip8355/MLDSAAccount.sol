// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MLDSA} from "./MLDSA.sol";

/// @title MLDSAAccount
/// @notice A simple smart account controlled by an ML-DSA (post-quantum signature) key.
///         ML-DSA（ポスト量子署名）の鍵で操作するシンプルなスマートアカウント。
/// @dev Example use case for EIP-8355. Public keys are large (1-2.5 KB), so only their
///      keccak256 hash is stored and the key itself is passed in calldata at execution.
///      The signed message includes chainid, the contract address and a nonce to prevent replay.
///      EIP-8355 のユースケース例。公開鍵は 1〜2.5KB と大きいため、ストレージには
///      keccak256 ハッシュだけを保存し、実行時に calldata で公開鍵を渡す。
///      署名対象メッセージは chainid・コントラクトアドレス・nonce を含めてリプレイを防ぐ。
contract MLDSAAccount {
    MLDSA.ParamSet public immutable paramSet;
    bytes32 public publicKeyHash;
    uint256 public nonce;

    event Executed(uint256 indexed nonce, address indexed target, uint256 value, bytes data);
    event PublicKeyRotated(bytes32 indexed oldHash, bytes32 indexed newHash);

    error UnknownPublicKey();
    error InvalidSignature();
    error CallFailed(bytes returnData);
    error OnlySelf();

    constructor(MLDSA.ParamSet paramSet_, bytes memory publicKey) {
        uint256 pkLen = MLDSA.publicKeyLength(paramSet_);
        if (publicKey.length != pkLen) revert MLDSA.InvalidPublicKeyLength(pkLen, publicKey.length);
        paramSet = paramSet_;
        publicKeyHash = keccak256(publicKey);
    }

    receive() external payable {}

    /// @notice The message to be signed. Off-chain signers produce an ML-DSA signature over these bytes.
    ///         署名対象のメッセージ。オフチェーンの署名者はこのバイト列に ML-DSA 署名する。
    function operationMessage(address target, uint256 value, bytes calldata data, uint256 opNonce)
        public
        view
        returns (bytes memory)
    {
        return abi.encode(block.chainid, address(this), opNonce, target, value, keccak256(data));
    }

    /// @notice Executes an arbitrary call authorized by an ML-DSA signature. Anyone can relay it.
    ///         ML-DSA 署名付きで任意の呼び出しを実行する。誰でもリレー可能。
    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        bytes calldata publicKey,
        bytes calldata signature
    ) external returns (bytes memory result) {
        if (keccak256(publicKey) != publicKeyHash) revert UnknownPublicKey();

        uint256 opNonce = nonce;
        if (!MLDSA.verify(paramSet, publicKey, signature, operationMessage(target, value, data, opNonce))) {
            revert InvalidSignature();
        }
        nonce = opNonce + 1;

        bool ok;
        (ok, result) = target.call{value: value}(data);
        if (!ok) revert CallFailed(result);
        emit Executed(opNonce, target, value, data);
    }

    /// @notice Rotates the key. Callable only via execute (a call to itself).
    ///         鍵のローテーション。execute 経由（自分自身への呼び出し）でのみ実行可能。
    function rotatePublicKey(bytes calldata newPublicKey) external {
        if (msg.sender != address(this)) revert OnlySelf();
        uint256 pkLen = MLDSA.publicKeyLength(paramSet);
        if (newPublicKey.length != pkLen) revert MLDSA.InvalidPublicKeyLength(pkLen, newPublicKey.length);
        bytes32 newHash = keccak256(newPublicKey);
        emit PublicKeyRotated(publicKeyHash, newHash);
        publicKeyHash = newHash;
    }
}
