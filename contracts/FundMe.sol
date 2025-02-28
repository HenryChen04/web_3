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

    address public owner;

    constructor (uint256 _startTime, uint256 _duration) {
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        startTime = _startTime;
        duration = _duration;
        owner = msg.sender;
    }

    // 创建一个收款函数
    function fundMe() external payable {
        require(block.timestamp > startTime, "The fund has not started");

        require(block.timestamp <= startTime + duration, "The fund is end");

        uint256 fundAmount = convertToUSD(msg.value);
        require(fundAmount >= MIN_AMOUNT, "You need to pay more ETH");

        // 记录投资人并且查看
        funders[msg.sender] = msg.value;
    }

    // 在锁定期内，达到目标值，生产商可以提款
    function getFund() external fundIsNotEnd{
        require(msg.sender == owner, "You are not the owner");

        uint256 totalFundAmount = address(this).balance;

        require(convertToUSD(totalFundAmount) >= MIN_FUND_GOAL, "The goal is not reached");

        bool res;
        (res,) = payable (msg.sender).call{value: totalFundAmount}("");

        require(res, "Get fund failed");
    }

    // 在锁定期内，没有达到目标值，投资人在锁定期以后退款
    function refund() external fundIsNotEnd{
        uint256 totalFundAmount = address(this).balance;
        require(convertToUSD(totalFundAmount) < MIN_FUND_GOAL, "The goal is reached");

        require(funders[msg.sender] != 0, "You have not fund");

        bool res;
        (res,) = payable (msg.sender).call{value: funders[msg.sender]}("");

        require(res, "Refund failed");

        funders[msg.sender] = 0;
    }

    function convertToUSD(uint256 _amount) private view returns (uint256){
       uint256 currentEthToUsd = uint256(getChainlinkDataFeedLatestAnswer());

       return (currentEthToUsd / 10 ** 8) * _amount;
    }

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

    modifier fundIsNotEnd() {
        require(block.timestamp > startTime + duration, "The fund is not end yet");
        _;
    }
}