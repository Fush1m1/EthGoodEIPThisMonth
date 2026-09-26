// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MLDSA
/// @notice Wrapper for calling the EIP-8355 (Precompiles for ML-DSA Verification) precompiles.
///         EIP-8355 (Precompiles for ML-DSA Verification) の呼び出しラッパー。
/// @dev Precompile spec (EIP-8355 Draft, as of 2026-09):
///      - Addresses: ML-DSA-44 = 0x12, ML-DSA-65 = 0x13, ML-DSA-87 = 0x14
///      - Input: pubkey ++ signature ++ message (no length prefixes)
///      - Output: always 32 bytes. 0x..01 = valid, 0x..00 = invalid / malformed
///      - Gas: BASE + 6 * ceil(len(message) / 32)
///      On chains without the precompile the address has no code, so STATICCALL succeeds
///      with empty returndata. To avoid treating that as "valid", this returns true only
///      when returndata is 32 bytes and equals 1.
///      プリコンパイルの仕様（EIP-8355 Draft, 2026-09 時点）:
///      - アドレス: ML-DSA-44 = 0x12, ML-DSA-65 = 0x13, ML-DSA-87 = 0x14
///      - 入力: pubkey ++ signature ++ message（長さプレフィックスなし）
///      - 出力: 常に 32 バイト。0x..01 = 有効、0x..00 = 無効/不正
///      - ガス: BASE + 6 * ceil(len(message) / 32)
///      プリコンパイルが未導入のチェーンではアドレスにコードが無く、STATICCALL は
///      成功して空の returndata を返す。これを「有効」と誤判定しないよう、
///      returndata が 32 バイトかつ値が 1 の場合のみ true を返す。
library MLDSA {
    enum ParamSet {
        MLDSA44,
        MLDSA65,
        MLDSA87
    }

    error InvalidPublicKeyLength(uint256 expected, uint256 actual);
    error InvalidSignatureLength(uint256 expected, uint256 actual);

    address internal constant VERIFY_MLDSA44 = address(0x12);
    address internal constant VERIFY_MLDSA65 = address(0x13);
    address internal constant VERIFY_MLDSA87 = address(0x14);

    uint256 internal constant MLDSA44_PK_LEN = 1312;
    uint256 internal constant MLDSA44_SIG_LEN = 2420;
    uint256 internal constant MLDSA65_PK_LEN = 1952;
    uint256 internal constant MLDSA65_SIG_LEN = 3309;
    uint256 internal constant MLDSA87_PK_LEN = 2592;
    uint256 internal constant MLDSA87_SIG_LEN = 4627;

    function precompile(ParamSet ps) internal pure returns (address) {
        if (ps == ParamSet.MLDSA44) return VERIFY_MLDSA44;
        if (ps == ParamSet.MLDSA65) return VERIFY_MLDSA65;
        return VERIFY_MLDSA87;
    }

    function publicKeyLength(ParamSet ps) internal pure returns (uint256) {
        if (ps == ParamSet.MLDSA44) return MLDSA44_PK_LEN;
        if (ps == ParamSet.MLDSA65) return MLDSA65_PK_LEN;
        return MLDSA87_PK_LEN;
    }

    function signatureLength(ParamSet ps) internal pure returns (uint256) {
        if (ps == ParamSet.MLDSA44) return MLDSA44_SIG_LEN;
        if (ps == ParamSet.MLDSA65) return MLDSA65_SIG_LEN;
        return MLDSA87_SIG_LEN;
    }

    /// @notice Estimates the verification cost using the EIP-8355 gas formula.
    ///         EIP-8355 のガス式に従った検証コストの見積もり。
    function verifyGas(ParamSet ps, uint256 messageLength) internal pure returns (uint256) {
        uint256 base = ps == ParamSet.MLDSA44 ? 6500 : ps == ParamSet.MLDSA65 ? 9000 : 13500;
        return base + 6 * ((messageLength + 31) / 32);
    }

    /// @notice Verifies an ML-DSA signature. Reverts if a length is invalid.
    ///         ML-DSA 署名を検証する。長さが不正な場合は revert する。
    function verify(ParamSet ps, bytes memory publicKey, bytes memory signature, bytes memory message)
        internal
        view
        returns (bool)
    {
        uint256 pkLen = publicKeyLength(ps);
        if (publicKey.length != pkLen) revert InvalidPublicKeyLength(pkLen, publicKey.length);
        uint256 sigLen = signatureLength(ps);
        if (signature.length != sigLen) revert InvalidSignatureLength(sigLen, signature.length);

        (bool ok, bytes memory ret) = precompile(ps).staticcall(abi.encodePacked(publicKey, signature, message));
        return ok && ret.length == 32 && abi.decode(ret, (uint256)) == 1;
    }

    /// @notice Checks whether the EIP-8355 precompile is available on this chain.
    ///         EIP-8355 のプリコンパイルがこのチェーンで有効かを判定する。
    /// @dev Empty input is shorter than PK_LEN + SIG_LEN, so if the precompile exists it
    ///      returns 32 zero bytes.
    ///      空入力は PK_LEN + SIG_LEN 未満なので、導入済みなら 32 バイトのゼロが返る。
    function isAvailable(ParamSet ps) internal view returns (bool) {
        (bool ok, bytes memory ret) = precompile(ps).staticcall("");
        return ok && ret.length == 32;
    }
}
