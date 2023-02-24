// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../src/Token.sol";

contract stakecontract{

    mapping(address => uint256) public amountstaked;
    uint256 stakestart;
    // uint256 stakestop;
    uint256 price = 0.000000000000001 ether;
    uint256 public numberoftokens;
    address private Owner;
    uint256 time;


    Token public t1;
    constructor (address _token, uint256 _time){
        t1 = Token(_token);
        Owner = msg.sender;
        time = _time;

    }

    function buyTokens() public payable {
        require(msg.value != 0 ether, "Invalid Input");
        numberoftokens = msg.value * price;
        numberoftokens = numberoftokens / 1000000000000000000;
        t1.transferFrom(Owner,msg.sender,numberoftokens);     

    }  

    function stake(uint256 tokenstostake) public {  //stake function that takes a uint
        require(t1.balanceOf(msg.sender) >= tokenstostake, "Not enough tokens"); //check if the user has enough tokens than what he's trying to stake
        require(tokenstostake > 0, "cannot stake 0 tokens"); //Check if the user is not staking 0 tokens
        require(amountstaked[msg.sender] == 0, "You already have tokens staked");
        t1.transferFrom(msg.sender, address(this), tokenstostake); //transfer the tokens from the user to contract
        stakestart = block.timestamp;   //to take the time the user stakes his tokens
        amountstaked[msg.sender] = tokenstostake;
    }

    function unstake(uint256 tokenstounstake) public{
        require(tokenstounstake <= amountstaked[(msg.sender)], "You cannot unstake more tokens than what you have staked"); //user cannot unstake more than what's at stake
        uint256 reward = calculateReward(msg.sender);
        require(amountstaked[msg.sender] >= tokenstounstake + reward, "You do not have enough tokens staked to unstake the requested amount");
        amountstaked[msg.sender] -= tokenstounstake + reward;
        t1.transfer(msg.sender,tokenstounstake + reward); //transfer the tokens + reward to the user
    }

    function calculateReward(address staker) public view returns (uint256) {  //to calulate the reward for staking
        uint256 stakedTokens = amountstaked[staker];   //to save the amount staked in a variable
        uint256 reward = stakedTokens / 1000; //take 0.01% of the total amount staked
        uint256 difftime =  block.timestamp - stakestart; //calculate the time the tokens were at stake
        difftime = difftime / time;
        reward *= difftime;  //Multiply the reward by the time at stake
        return reward;
    }
}
