// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;


    int minRequiredUSD;
    int etherPriceUSD;
    int public minRequiredEther;
    int public demoStandardPrice;
    int public demoVipPrice;

    /**
     * Network: Rinkeby
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    
        minRequiredUSD = 50*10**18;
        etherPriceUSD = (correct()*10**18);

        minRequiredEther = (minRequiredUSD*10**18)/etherPriceUSD;

    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function correct() public view returns (int) {
        return (getLatestPrice() / 100000000);
    }

    function standardTicket() public view returns(uint256) {
         uint256 adjustedPrice = uint256(minRequiredEther);
         return adjustedPrice;
        
    }

    function vipTicket() public view returns(uint256) {
        uint256 vipAdjustedPrice = uint256(minRequiredEther * 2);
        return vipAdjustedPrice;
    }

    function getDemoStandardPrice() public view returns(uint256) {
        uint256 adjustedPrice = uint256(minRequiredEther / 10);
        return adjustedPrice;
    }

    function getDemoVipPrice() public view returns(uint256) {
        uint256 newNumber = uint256(minRequiredEther / 10);
        uint256 vipAdjustedPrice = uint256(newNumber * 2);
        return vipAdjustedPrice;
    }




}
