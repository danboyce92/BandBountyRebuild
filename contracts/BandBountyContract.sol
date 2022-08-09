// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './ModifiersContract.sol';
import './PriceFeed.sol';

contract Bounty is Modifiers , PriceConsumerV3  {

    //Mappings
    mapping(address => uint) balances;
    mapping(address => uint) contributors;
    mapping(address => bool) vipContributors;


    //Variables
    uint256 private totalBountyBalance;
    uint256 deploymentTime;
    uint256 setStateCounter;
    uint256 private contributorsCount;
    uint256 private target;
    uint256 expirationTime;
    uint256 currentTime = block.timestamp;


    //Standard Tickets
    uint256 standardTicketCounter = 0;
    address[10000] standardTicketHolders;
    mapping(address => uint) private standardTicketsOwned;

    //VIP Tickets
    uint256 vipTicketCounter = 0;
    address[101] vipTicketHolders;

    //Refund mappings
    mapping(address => uint) numberOfTickets;
    mapping(address => bool) refundOnce;

    //Refund mappings to store price user paid for ticket
    mapping(address => uint) standardUserCost;
    mapping(address => uint) vipUserCost;

    

    constructor(address manager) payable {
        //manager here is creator of bounty, not admin
        manager = msg.sender;
        state = 1;
        deploymentTime = currentTime;
        expirationTime = currentTime += 90 days;
        target = 50 ether;

    }


    //Functions


    function setState(uint _state)public onlyAdmin {
        //onlyOwner needs to be set to onlyAdmin
        require(setStateCounter == 0, "State can only be changed once");
        require(state != 0, "State cannot be changed if bounty expires");

        state = _state;
        // 0 = Red,  1 = Yellow,  2 = Green,  3 = Complete

        //This updates deadline if bounty is greenlit
        if(_state == 2){
            deploymentTime = currentTime;
            expirationTime = currentTime += 90 days;

        }
        //To prevent state being exploited by admin
        setStateCounter++;
    }



    function contribute() public payable notRed {
        require(state != 3, "This Bounty is closed");

        currentTime = block.timestamp;
        

        if(totalBountyBalance + msg.value >= target){
            state = 3;
        }

        if(currentTime > expirationTime && state != 3){
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

        //Update the contracts Total Balance
        totalBountyBalance += msg.value;
        


    }

    //Adding contributors to their group Standard or Vip
    
    function claimStandardTicket() public payable notRed {
        require(balances[msg.sender] >= /*standardTicket()*/ getDemoStandardPrice(), "Not enough funds");

        uint standardTicketCost = getDemoStandardPrice();

            //deduct cost first
            balances[msg.sender] -= /*standardTicket()*/ standardTicketCost;

            standardTicketHolders[standardTicketCounter] = msg.sender;
            standardTicketCounter++;

            //So users can keep track of how many tickets they own
            standardTicketsOwned[msg.sender]++;

            //for refund function
            numberOfTickets[msg.sender]++;

            //to store price paid in case of refund
            standardUserCost[msg.sender] = standardTicketCost;
        
    }

    function claimVipTicket() public payable greenOnly notRed {
        require(vipTicketCounter < 101, "Vip List full");
        require(balances[msg.sender] >= /*vipTicket()*/ getDemoVipPrice(), "Not enough funds");
        
        uint vipTicketCost = getDemoVipPrice();

        //1 Vip ticket per person
        require(vipContributors[msg.sender] == false);

            //deduct cost first
            balances[msg.sender] -= /*vipTicket()*/ vipTicketCost;
            
            vipContributors[msg.sender] = true;
            vipTicketHolders[vipTicketCounter] = msg.sender;
            vipTicketCounter++;

            //to store price paid in case of refund
            vipUserCost[msg.sender] = vipTicketCost;

    }

    function refund() public payable redOnly {
        //Double check for re-entrancy vulnerability
        require(refundOnce[msg.sender] == false, "Can only refund once");

        refundOnce[msg.sender] == true;

            if(vipContributors[msg.sender] == true){
                balances[msg.sender] += /*vipTicket()*/ vipUserCost[msg.sender];
            }

            if(numberOfTickets[msg.sender] > 0){
                balances[msg.sender] += /*standardTicket()*/ standardUserCost[msg.sender] * numberOfTickets[msg.sender];
            }

        payable (msg.sender).transfer(balances[msg.sender]);

        balances[msg.sender] = 0;

    }

    function setTarget(uint256 _target) public greenOnly onlyAdmin {
        //needs onlyAdmin
        target = _target;
    }



    function withdrawFunds(address payable recipient) payable public onlyAdmin bountyComplete {
        //onlyOwner doesn't work here
        //This would allow the user who created the bounty to withdraw
        //This function should be reserved for admin only

        recipient.transfer(totalBountyBalance);

    }

    //Can I invoke this function everytime frontend is refreshed?
    function timeRemaining() public view returns (uint) {
    if (expirationTime <= block.timestamp) {
        return 0;
    } else {
        return expirationTime - block.timestamp;
    }

    }



    //Getter functions

    function getTotalBountyBalance() public view returns(uint) {
        return totalBountyBalance;
    }

    function getContributorsCount() public view returns(uint) {
        return contributorsCount;
    }

    function getTarget() public view returns(uint) {
        return target;
    }

    function getUserBalance(address user) public view returns(uint) {
        return balances[user];
    }

    function getStandardTicketsOwned(address user) public view returns(uint) {
        return standardTicketsOwned[user];
    }

}