// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakingContract.sol";
import "../src/Token.sol";

contract TestStakeContract is Test {
    stakecontract public stc;
    Token public t1;
    uint256 public staticTime;
    uint256 STAKE_AMOUNT = 1000;
    uint256 TIME  = 60;

    function setUp() public {
        t1 = new Token();
        stc = new stakecontract(address(t1), 60);
        staticTime = block.timestamp;
        
        
    }

    function testStake(uint16 amount) public {
        // Stake some tokens for an account
        // t1.transfer(address(stc), 1000);
        stc.stake(amount);
        
        // Check the amount of tokens staked for the account
        uint256 amountStaked = stc.amountstaked(address(this));
        assertEq(amountStaked,amount);
    }

    function testReward() public {
        stc.stake(1000);
        uint256 reward = STAKE_AMOUNT / 1000;
        uint256 difftime =  block.timestamp - staticTime;
        uint256 expectedreward = reward *= (difftime);
        uint256 actualreward = stc.calculateReward(address(this));
        vm.warp(block.timestamp + 500);
        assertEq(expectedreward,actualreward);

        
    }

}
