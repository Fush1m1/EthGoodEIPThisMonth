// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BurnProbe, SelfBurner, SupplyBurner} from "../src/eip8246/SelfDestructBurn.sol";

/// @dev 現行 EVM（EIP-8246 未導入）での挙動を確認するテスト。
///      EIP-8246 が有効な EVM で実行すると、焼却されずに残高が残る側に結果が反転する。
contract SelfDestructBurnTest is Test {
    function test_SelfBurnerBurnsBeforeEip8246() public {
        SelfBurner burner = new SelfBurner{value: 1 ether}();
        assertEq(address(burner).balance, 0, "ETH should be burned pre EIP-8246");
        assertEq(address(burner).code.length, 0, "constructor selfdestruct leaves no code");
    }

    function test_ProbeReportsBurnStillActive() public {
        BurnProbe probe = new BurnProbe();
        assertFalse(probe.isBurnRemoved{value: 1}(), "EIP-8246 is not active on this EVM");
    }

    function test_SupplyBurnerSendsToDead() public {
        SupplyBurner burner = new SupplyBurner();
        uint256 before = burner.DEAD().balance;
        burner.burn{value: 1 ether}();
        assertEq(burner.DEAD().balance - before, 1 ether, "not sent to dead address");
    }
}
