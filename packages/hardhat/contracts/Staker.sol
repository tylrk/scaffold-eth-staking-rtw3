// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

// Check

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  // Mappings
  mapping(address => uint256) public balances;
  mapping(address => uint256) public depositTimestamp;

  // Variables
  uint256 public constant rewardRatePerSecond = 0.1 ether; 
  uint256 public withdrawalDeadline = block.timestamp + 120 seconds; 
  uint256 public claimDeadline = block.timestamp + 240 seconds; 
  uint256 public currentBlock = 0;

  // Events
  event Stake(address indexed sender, uint256 amount); 
  event Received(address, uint); 
  event Execute(address indexed sender, uint256 amount);

  modifier withdrawalDeadlineReached( bool requireReached ) {
    uint256 timeRemaining = withdrawalTimeLeft();
    if( requireReached ) {
      require(timeRemaining == 0, "Withdrawal period is not reached yet");
    } else {
      require(timeRemaining > 0, "Withdrawal period has been reached");
    }
    _;
  }

  modifier claimDeadlineReached( bool requireReached ) {
    uint256 timeRemaining = claimPeriodLeft();
    if( requireReached ) {
      require(timeRemaining == 0, "Claim deadline is not reached yet");
    } else {
      require(timeRemaining > 0, "Claim deadline has been reached");
    }
    _;
  }

  modifier notCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "Stake already completed!");
    _;
  }

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  function withdrawalTimeLeft() public view returns (uint256 withdrawalTimeLeft) {
    if( block.timestamp >= withdrawalDeadline) {
      return (0);
    } else {
       return (withdrawalDeadline - block.timestamp);
    }
  }

  function claimPeriodLeft() public view returns (uint256 claimPeriodLeft) {
    if( block.timestamp >= claimDeadline) {
      return (0);
    } else {
      return (claimDeadline - block.timestamp);
    }
  }

}
