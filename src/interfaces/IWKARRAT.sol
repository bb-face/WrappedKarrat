// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/interfaces/IERC20.sol";

interface IWKARRAT is IERC20 {
    /// @notice Deposit native KARRAT and receive WKARRAT
    function deposit() external payable;

    /// @notice Withdraw WKARRAT and receive native KARRAT
    /// @param amount The amount to withdraw
    function withdraw(uint256 amount) external;

    /// @notice Emitted when KARRAT is deposited
    event Deposit(address indexed account, uint256 amount);

    /// @notice Emitted when WKARRAT is withdrawn
    event Withdrawal(address indexed account, uint256 amount);
}
