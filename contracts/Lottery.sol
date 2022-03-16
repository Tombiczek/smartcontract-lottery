// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Lottery {
    // we need to keep track of all the people that enter the lottery
    address payable [] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPreceFeed;

    constructor(address _priceFeedAddress) public {
        usdEntryFee = 50*(10**18);
        ethUsdPreceFeed = AggregatorV3Interface(_priceFeedAddress);
        
    }

    function enter() public payable {
        // $50 minimum
        require(msg.value >= getEntranceFee(), "Not enough ETH!");
        players.push(payable(msg.sender));
    }

    function getEntranceFee() public view returns (uint256) {
        (
        /*uint80 roundID*/,
        int256 price,
        /*uint startedAt*/,
        /*uint timeStamp*/,
        /*uint80 answeredInRound*/
        ) = ethUsdPreceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price)*(10**10); // we need 18 decimals
        // $50, $2000/ETH
        // 50/2000 but there cannot be any decimals
        // 50 * 1000000 / 2000
        uint256 costToEnter = (usdEntryFee * 10**18) / adjustedPrice;
        return costToEnter;
    }

    function startLottery() public {}

    function endLottery() public {}

}