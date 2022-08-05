// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.9.0;

contract Modifiers {

    //this is my metamask account used to demo this project
    address admin = 0x5C3d553769D4473d53dF67b04Eb0f51D3C7705D8;
    uint public state;


    modifier onlyAdmin() {
        require(msg.sender == admin);
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

    modifier bountyComplete() {
        require(state == 3, "Must be in COMPLETE state");
        _;
    }


}