// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @dev forge-std を使わずに済ませるための最小限の cheatcode インターフェース。
interface Vm {
    function etch(address target, bytes calldata code) external;
    function deal(address account, uint256 balance) external;
    function expectRevert(bytes4 selector) external;
    function expectRevert(bytes calldata revertData) external;
}

abstract contract TestBase {
    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function assertTrue(bool value, string memory message) internal pure {
        require(value, message);
    }

    function assertEq(uint256 a, uint256 b, string memory message) internal pure {
        require(a == b, message);
    }
}
