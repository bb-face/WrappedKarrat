// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/WKARRAT.sol";

contract WKARRATTest is Test {
    WKARRAT public wkarrat;
    address public alice;
    address public bob;

    function setUp() public {
        wkarrat = new WKARRAT();
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        vm.deal(alice, 100 ether); // 100 KARRAT
        vm.deal(bob, 100 ether);
    }

    function test_Metadata() public view {
        assertEq(wkarrat.name(), "Wrapped KARRAT");
        assertEq(wkarrat.symbol(), "WKARRAT");
        assertEq(wkarrat.decimals(), 18);
    }

    function test_Deposit() public {
        vm.startPrank(alice);

        uint256 depositAmount = 10 ether;
        wkarrat.deposit{value: depositAmount}();

        assertEq(wkarrat.balanceOf(alice), depositAmount);
        assertEq(wkarrat.totalSupply(), depositAmount);
        assertEq(address(wkarrat).balance, depositAmount);

        vm.stopPrank();
    }

    function test_DepositViaReceive() public {
        vm.startPrank(alice);

        uint256 depositAmount = 5 ether;
        (bool success,) = address(wkarrat).call{value: depositAmount}("");
        assertTrue(success);

        assertEq(wkarrat.balanceOf(alice), depositAmount);

        vm.stopPrank();
    }

    function test_Withdraw() public {
        vm.startPrank(alice);

        uint256 depositAmount = 10 ether;
        wkarrat.deposit{value: depositAmount}();

        uint256 balanceBefore = alice.balance;

        uint256 withdrawAmount = 5 ether;
        wkarrat.withdraw(withdrawAmount);

        assertEq(wkarrat.balanceOf(alice), depositAmount - withdrawAmount);
        assertEq(alice.balance, balanceBefore + withdrawAmount);
        assertEq(wkarrat.totalSupply(), depositAmount - withdrawAmount);

        vm.stopPrank();
    }

    function test_WithdrawInsufficientBalance() public {
        vm.startPrank(alice);

        wkarrat.deposit{value: 1 ether}();

        vm.expectRevert("WKARRAT: insufficient balance");
        wkarrat.withdraw(2 ether);

        vm.stopPrank();
    }

    function test_Transfer() public {
        vm.startPrank(alice);

        wkarrat.deposit{value: 10 ether}();
        wkarrat.transfer(bob, 3 ether);

        assertEq(wkarrat.balanceOf(alice), 7 ether);
        assertEq(wkarrat.balanceOf(bob), 3 ether);

        vm.stopPrank();
    }

    function test_TransferInsufficientBalance() public {
        vm.startPrank(alice);

        wkarrat.deposit{value: 1 ether}();

        vm.expectRevert("WKARRAT: insufficient balance");
        wkarrat.transfer(bob, 2 ether);

        vm.stopPrank();
    }

    function test_Approve() public {
        vm.startPrank(alice);

        wkarrat.approve(bob, 5 ether);
        assertEq(wkarrat.allowance(alice, bob), 5 ether);

        vm.stopPrank();
    }

    function test_TransferFrom() public {
        vm.startPrank(alice);
        wkarrat.deposit{value: 10 ether}();
        wkarrat.approve(bob, 5 ether);
        vm.stopPrank();

        vm.startPrank(bob);
        wkarrat.transferFrom(alice, bob, 3 ether);
        vm.stopPrank();

        assertEq(wkarrat.balanceOf(alice), 7 ether);
        assertEq(wkarrat.balanceOf(bob), 3 ether);
        assertEq(wkarrat.allowance(alice, bob), 2 ether);
    }

    function test_TransferFromInsufficientAllowance() public {
        vm.startPrank(alice);
        wkarrat.deposit{value: 10 ether}();
        wkarrat.approve(bob, 1 ether);
        vm.stopPrank();

        vm.startPrank(bob);
        vm.expectRevert("WKARRAT: insufficient allowance");
        wkarrat.transferFrom(alice, bob, 2 ether);
        vm.stopPrank();
    }

    function test_OneToOneRatio() public {
        vm.startPrank(alice);

        uint256 initialBalance = alice.balance;
        uint256 amount = 25 ether;

        wkarrat.deposit{value: amount}();
        assertEq(alice.balance, initialBalance - amount);
        assertEq(wkarrat.balanceOf(alice), amount);

        wkarrat.withdraw(amount);
        assertEq(alice.balance, initialBalance);
        assertEq(wkarrat.balanceOf(alice), 0);

        vm.stopPrank();
    }
}
