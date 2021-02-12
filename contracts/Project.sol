// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Project {
    // need 3 functions
    // need some random way of activating any of these
    // need to figure out how to get input from outside the contract
    // need to use the input to affect the random usage of a function
    // need to learn how to keep track of gas usage
    // need to keep track of gas usage per address
    // need to have function to close competition
    // need to have function to return the points table and winner address

    uint start;
    uint expiration;
    address [] competitors;
    mapping (address => uint)Project;

    constructor()public payable {
        start = now;
        expiration = start + msg.duration * 1 days;
    }

    modifier competitionExpired() {
        require(
            now <= expiration
        );
        _;
    }

    function endpoint()public {
        // something from the sender
        // with some random event occuring using the message
        //
    }

    function random_first()private pure {
        competitors
    }

    function random_second()private pure {

    }

    function random_third()private pure {

    }
}
