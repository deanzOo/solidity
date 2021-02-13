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
    mapping (address => uint)Scores;
    mapping (address =>uint)Submissions;

    constructor(uint _daysActive) payable {
        start = block.timestamp;
        expiration = start + _daysActive * 1 days;
    }

    // prevents accessing contract after expiration date
    modifier competitionNotExpired() {
        require(
            block.timestamp <= expiration
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
    function endpoint(bytes calldata _answer) public
    competitionNotExpired competitorSubmittedEnough(msg.sender){
        init_competitor(msg.sender);
        Submissions[msg.sender] += 1;
        Scores[msg.sender] += random_gas_use(_answer);
    }

    // get scores
    function getScores() public pure returns (uint32 [] calldata, uint32 [] calldata) {
        uint [] storage formatted_scores;
        for (uint i = 0; i < competitors.length; i++)
            formatted_scores.push(uint32(Scores[competitors[i]]));
        return (competitors, formatted_scores);
    }

    // use gas randomly based on _limit_base
    function random_gas_use(bytes calldata _limit_base) private pure returns (uint)
    {
        uint limit = chooseRandomLimit(uint(_limit_base));
        uint base = block.timestamp;
        uint old_gas_used = gasleft();
        for (uint i = 0; i < limit; i++) {
            uint j = (i % base) * ((limit * i) % base);
        }
        return gasleft() - old_gas_used;
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
            Scores[ _sender] = 0;
            Submissions[ _sender] = 1;
        }
    }

    // some random way of choosing a scoring for the competitor
    // in real world situations, this will not be chosen randomly, but by specific answers and success
    function chooseRandomLimit(uint _bet) private pure returns (uint){
        return uint(uint(keccak256(block.difficulty, _bet)) * uint(keccak256(block.timestamp)));
    }

}
