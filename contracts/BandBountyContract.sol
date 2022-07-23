// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './ModifiersContract.sol';
import './PriceFeed.sol';

contract BandBounty is Modifiers, PriceConsumerV3 {

    //Mappings
    mapping(address => uint) balances;
    mapping(address => uint) contributors;


    //Variables
    uint256 deploymentTime;
    uint256 setStateCounter;
    uint256 public contributorsCount;
    

    constructor() payable {
        manager = msg.sender;
        state = 1;
        deploymentTime = block.timestamp;

    }


    //Functions

    function setState(uint _state)public onlyOwner {
        require(setStateCounter == 0, "State can only be changed once");

        state = _state;
        // 0 = Red,  1 = Yellow,  2 = Green,  3 = Complete

        if(_state == 2){
            deploymentTime = block.timestamp;

        }

        setStateCounter++;
    }



    function contribute() public payable notRed {
        uint expirationTime = deploymentTime + 90 days;
        uint currentTime = block.timestamp;

        if(currentTime > expirationTime){
            state = 0;
        }

        /* Contributors allows front end to keep track
        of number of people involved */
        if(contributors[msg.sender] == 0){
            contributorsCount++;
        }
        //This makes sure a single contributor isn't counted twice
        contributors[msg.sender] = 1;

        //Update users balance with new contribution
        balances[msg.sender] += msg.value;

    }


}