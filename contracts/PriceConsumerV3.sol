// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
  AggregatorV3Interface public priceFeed;

  constructor() public {
    // Chainlink Oracle for ETH/USD
    // Sepolia: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    // Main net: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
    priceFeed = AggregatorV3Interface(
      0x694AA1769357215DE4FAC081bf1f309aDC325306
    );
  }

  function getLatestPrice() public view returns (int) {
    (, int price, , , ) = priceFeed.latestRoundData();
    return price;
  }

  function getDecimals() public view returns (uint8) {
    uint8 decimals = priceFeed.decimals();
    return decimals;
  }
}
