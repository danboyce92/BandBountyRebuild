// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

contract Modifiers {

    address manager;
    uint public state;


    modifier onlyOwner() {
        require(msg.sender == manager);
        _;
    }

    modifier redOnly() {
        require(state == 0, "Must be in RED state");
        _;
    }

    modifier greenOnly() {
        require(state == 2, "Must be in GREEN state");
        _;
    }

    modifier notRed() {
        require(state != 0, "Must not be in RED state");
        _;
    }


}