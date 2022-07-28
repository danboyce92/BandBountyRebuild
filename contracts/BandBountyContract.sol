// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './ModifiersContract.sol';
import './PriceFeed.sol';

contract BandBounty is Modifiers /*, PriceConsumerV3*/  {

    //Mappings
    mapping(address => uint) public balances;
    mapping(address => uint) contributors;
    mapping(address => bool) vipContributors;


    //Variables
    uint256 public totalBountyBalance;
    uint256 public deploymentTime;
    uint256 setStateCounter;
    uint256 public contributorsCount;
    uint256 target;


    //Standard Tickets
    uint256 public standardTicketCounter = 0;
    address[10000] public standardTicketHolders;

    //VIP Tickets
    uint256 vipTicketCounter = 0;
    address[101] vipTicketHolders;

    //Refund mappings
    mapping(address => uint) numberOfTickets;
    mapping(address => bool) refundOnce;

    

    constructor() {
        manager = msg.sender;
        state = 1;
        deploymentTime = block.timestamp;

    }


    //Functions


    function setState(uint _state)public onlyOwner {
        require(setStateCounter == 0, "State can only be changed once");
        require(state != 0, "State cannot be changed if bounty expires");

        state = _state;
        // 0 = Red,  1 = Yellow,  2 = Green,  3 = Complete

        //This updates deadline if bounty is greenlit
        if(_state == 2){
            deploymentTime = block.timestamp;

        }
        //To prevent state being exploited by admin
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

        //Update the contracts Total Balance
        totalBountyBalance += msg.value;


    }

    //Adding contributors to their group Standard or Vip
    
    function claimStandardTicket() public payable notRed {
        require(balances[msg.sender] >= /*standardTicket()*/ 500, "Not enough funds");

            //deduct cost first
            balances[msg.sender] -= /*standardTicket()*/ 500;

            standardTicketHolders[standardTicketCounter] = msg.sender;
            standardTicketCounter++;

            //for refund function
            numberOfTickets[msg.sender]++;
        
    }

    function claimVipTicket() public payable greenOnly notRed {
        require(vipTicketCounter < 101, "Vip List full");
        require(balances[msg.sender] >= /*vipTicket()*/ 1000, "Not enough funds");
        //1 Vip ticket per person
        require(vipContributors[msg.sender] == false);

            //deduct cost first
            balances[msg.sender] -= /*vipTicket()*/ 1000;
            
            vipContributors[msg.sender] = true;
            vipTicketHolders[vipTicketCounter] = msg.sender;
            vipTicketCounter++;

    }

    function refund() public payable redOnly {
        //Double check for re-entrancy vulnerability
        require(refundOnce[msg.sender] == false, "Can only refund once");

        refundOnce[msg.sender] == true;

        if(vipContributors[msg.sender] == true){
            balances[msg.sender] += /*vipTicket()*/ 1000;
        }

        if(numberOfTickets[msg.sender] > 0){
            balances[msg.sender] += /*standardTicket()*/ 500 * numberOfTickets[msg.sender];
        }


        payable (msg.sender).transfer(balances[msg.sender]);

        balances[msg.sender] = 0;



    }


    function withdrawFunds(address payable recipient) payable public onlyOwner bountyComplete {
        //onlyOwner doesn't work here
        //This would allow the user who created the bounty to withdraw
        //This function should be reserved for admin only

        recipient.transfer(totalBountyBalance);

    }


}