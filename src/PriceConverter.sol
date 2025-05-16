// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; 

// Why is this a library and not abstract?
// Why not an interface?
contract PriceConverter  {
    // We could make this public, but then we'd have to deploy it

     address public priceFeedAddress;

    constructor(address _priceFeedAddress) {
        priceFeedAddress = _priceFeedAddress;
    }

    function getPrice() public view returns (uint256) {
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            // 0x694AA1769357215DE4FAC081bf1f309aDC325306 ETH/USD
            // 0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526 BNB/USD
             priceFeedAddress
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    // 1000000000
    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
        // ethamount = 0.000771e18
        // ethPrice = 6530000000000 * 0.000771e18
        // inUsd =  6530000000000 * 770000000000000/ 1000000000000000000;
    }
}