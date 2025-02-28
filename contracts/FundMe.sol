// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    mapping (address => uint256) public funders;

    uint256 constant MIN_AMOUNT = 10 * 10 ** 18; // Wei

    uint256 constant MIN_FUND_GOAL = 20 * 10 ** 18;

    AggregatorV3Interface internal dataFeed;

    uint256 public startTime;

    uint256 public duration;

    constructor (uint256 _startTime, uint256 _duration) {
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        startTime = _startTime;
        duration = _duration;
    }

    // 创建一个收款函数
    function fundMe() external payable {
        require(block.timestamp > startTime, "The fund has not started");

        require(block.timestamp <= startTime + duration, "The fund is end");

        uint256 fundAmount = convertToUSD(msg.value);
        require(fundAmount >= MIN_AMOUNT, "You need to pay more");

        funders[msg.sender] = fundAmount;
    }

    function convertToUSD(uint256 _amount) internal view returns (uint256){
       uint256 currentEthToUsd = uint256(getChainlinkDataFeedLatestAnswer());

       return (currentEthToUsd / 10 ** 8) * _amount;
    }

    // 记录投资人并且查看

    // 在锁定期内，达到目标值，生产商可以提款

    // 在锁定期内，没有达到目标值，投资人在锁定期以后退款

     /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
}