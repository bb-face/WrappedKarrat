// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/interfaces/IERC20.sol";
import "./interfaces/IWKARRAT.sol";

contract WKARRAT is IWKARRAT {
    string public name = "Wrapped KARRAT";
    string public symbol = "WKARRAT";
    uint8 public decimals = 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    /// @inheritdoc IERC20
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
        emit Transfer(address(0), msg.sender, msg.value);
    }

    /// @inheritdoc IERC20
    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "WKARRAT: insufficient balance");
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    /// @inheritdoc IERC20
    receive() external payable {
        deposit();
    }

    /// @inheritdoc IERC20
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    /// @inheritdoc IERC20
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "WKARRAT: transfer to zero address");
        require(balanceOf[msg.sender] >= value, "WKARRAT: insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /// @inheritdoc IERC20
    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /// @inheritdoc IERC20
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "WKARRAT: transfer to zero address");
        require(balanceOf[from] >= value, "WKARRAT: insufficient balance");
        require(allowance[from][msg.sender] >= value, "WKARRAT: insufficient allowance");

        balanceOf[from] -= value;
        allowance[from][msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }
}
