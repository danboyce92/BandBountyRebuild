// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

import './BandBountyContract.sol';

contract BountyFactory {
    Bounty[] public deployedBounties;
    
    function createBounty(address creator) external payable {
        Bounty bounty = new Bounty{value: 111}(creator);
        deployedBounties.push(bounty);
        

    /*function getDeployedBounties() public view returns(Bounty[] memory) {
        return deployedBounties;
    }*/

    }
}


/*
// function arguments are passed to the constructor of the new created contract 
  function createBank(address _owner, uint256 _funds) external {
    bank = new Bank(_owner, _funds);
    list_of_banks.push(bank);
  }

  */