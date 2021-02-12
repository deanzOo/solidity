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
    mapping (address => uint)Score;
    mapping (address =>uint)Submissions;

    constructor()public payable {
        start = now;
        expiration = start + msg.duration * 1 days;
    }

    // prevents accessing contract af
    modifier competitionNotExpired() {
        require(
            now <= expiration
        );
        _;
    }

    // prevents competitors to submit more the 3 times
    modifier competitorSubmittedEnough(address _competitor) {
        require(
            !is_competitor(_competitor) || Submissions[_competitor] <= 3
        );
        _;
    }

    // public endpoint for all competitors to submit their bets
    function endpoint() public
    competitionNotExpired competitorSubmittedEnough(msg.sender){
        init_competitor(msg.sender);
        Submissions[msg.sender] += 1;
        Score[msg.sender] += random_gas_use(msg.data);
    }

    // get scores
    function getScores() public pure returns (uint [], uint []) {
        uint [] formatted_scores;
        for (uint i = 0; i < competitors.length; i++)
            formatted_scores.push(Scores[competitors[i]]);
        return competitors, formatted_scores;
    }

    /*******************************************************************************
        functions that were chosen randomly'ish to decide scores for competitors
    *********************************************************************************/
    function random_gas_use(uint _limit_base) private pure returns (uint)
    {
        uint limit = chooseRandomLimit(_limit_base);
        uint old_gas_used = gasleft();
        for (uint i = 0; i < limit; i++) {
            uint j = (i % 3) * ((limit * i) % 3);
        }
        return gas_used = gas_left() - old_gas_used;
    }

    /*******************************************************************************
                                   Helper Functions
    *********************************************************************************/
    // simple way of checking if competitor already submitted or not
    function is_competitor(address _sender) private pure returns (bool) {
        for (uint i = 0; i < competitors.length; i++)
            if (competitors[i] == _sender)
                return true;
        return false;
    }

    // if it's first submission for the competitor, lets enter him into the data base
    function init_competitor(address _sender) private {
        if (!is_competitor( _sender)) {
            competitors.push( _sender);
            Score[ _sender] = 0;
            Submissions[ _sender] = 1;
        }
    }

    // some random way of choosing a scoring for the competitor
    // in real world situations, this will not be chosen randomly, but by specific answers and success
    function chooseRandomLimit(uint _bet) private pure returns (uint){
        return (uint(keccak256(block.difficulty, _bet) * keccak256(now)) % 3) + 1;
    }

}
