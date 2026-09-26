// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title SelfBurner
/// @notice 生成と同じトランザクション内で自分自身を受取人に SELFDESTRUCT し、
///         受け取った ETH を焼却するコントラクト（OP Stack の L2ToL1MessagePasser.burn()
///         と同じパターン）。
/// @dev EIP-6780 以降も「同一 tx で生成 + 自分宛て SELFDESTRUCT」なら ETH は焼却される。
///      EIP-8246（Remove SELFDESTRUCT Burn, 2026-09 に Last Call）が有効になると
///      残高はそのまま残り、コード・ストレージ・nonce だけがクリアされた
///      「残高のみのアカウント」になる。つまり ETH は焼却されなくなる。
contract SelfBurner {
    constructor() payable {
        selfdestruct(payable(address(this)));
    }
}

/// @title BurnProbe
/// @notice 現在のチェーンで EIP-8246 が有効か（SELFDESTRUCT による焼却が廃止済みか）を
///         オンチェーンで判定する。
contract BurnProbe {
    /// @notice 1 wei を SelfBurner に送り、生成直後の残高を確認する。
    /// @return burnRemoved true なら EIP-8246 が有効（残高が残った）。
    /// @dev EIP-8246 以前: 自分宛て SELFDESTRUCT の時点で残高は 0 になる。
    ///      EIP-8246 以後: 残高は変わらない（tx 終了時に残高のみのアカウントとして残る）。
    ///      判定に使った 1 wei は、EIP-8246 以後は SelfBurner のアドレスに残る。
    function isBurnRemoved() external payable returns (bool burnRemoved) {
        require(msg.value == 1, "send exactly 1 wei");
        SelfBurner burner = new SelfBurner{value: 1}();
        burnRemoved = address(burner).balance == 1;
    }
}

/// @title SupplyBurner
/// @notice L2 などで ETH の焼却に SELFDESTRUCT を使っている箇所の移行例。
/// @dev EIP-8246 後は SELFDESTRUCT では焼却できなくなる（EVM から ETH を総供給量ごと
///      消す最後の手段がなくなる）。代替として誰も秘密鍵を持たないアドレスへ送って凍結する。
///      総供給量の数字自体は減らないため、供給量の会計はチェーン側で別途扱う必要がある。
contract SupplyBurner {
    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;

    event Burned(address indexed from, uint256 amount);

    function burn() external payable {
        (bool ok,) = DEAD.call{value: msg.value}("");
        require(ok, "transfer failed");
        emit Burned(msg.sender, msg.value);
    }
}
