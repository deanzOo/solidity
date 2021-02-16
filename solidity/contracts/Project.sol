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
    address payable [] competitors;
    mapping (address => uint)Scores;
    mapping (address => uint)Submissions;
    uint [] formatted_scores;

    uint _LIM = 50;

    constructor(uint _daysActive) payable {
        start = block.timestamp;
        expiration = start + _daysActive * 1 days;
    }

    // prevents competitors to submit more the 3 times
    modifier competitorSubmittedEnough(address _competitor) {
        require(
            !is_competitor(_competitor) || Submissions[_competitor] <= 3 || this.expired()
        );
        _;
    }

    // public endpoint for all competitors to submit their bets
    function endpoint(uint _answer) public
    competitorSubmittedEnough(msg.sender){
        if (this.expired()) {
            uint max_index = 0;
            for (uint i = 0; i < competitors.length; i++)
                if (Scores[competitors[i]] > max_index)
                    max_index = i;
            selfdestruct(competitors[max_index]);
        }
        init_competitor(msg.sender);
        Submissions[msg.sender] += 1;
        Scores[msg.sender] = random_gas_use(_answer);
    }

    function expired() public view returns (bool) {
        return block.timestamp > expiration;
    }

    function expire() public {
        expiration = 0;
    }

    // use gas randomly based on _limit_base
    function random_gas_use(uint _limit_base) private view returns (uint)
    {
        uint limit = chooseRandomLimit(_limit_base);
        uint old_gas_used = gasleft();
        for (uint i = 0; i < limit; i++) {
            mulmod(block.difficulty, block.timestamp, limit);
        }
        return gasleft() - old_gas_used;
    }

    /*******************************************************************************
                                   Helper Functions
    *********************************************************************************/
    // simple way of checking if competitor already submitted or not
    function is_competitor(address _sender) private view returns (bool) {
        for (uint i = 0; i < competitors.length; i++)
            if (competitors[i] == _sender)
                return true;
        return false;
    }

    // if it's first submission for the competitor, lets enter him into the data base
    function init_competitor(address payable _sender) private {
        if (!is_competitor(_sender)) {
            competitors.push(_sender);
        }
    }

    // some random way of choosing a scoring for the competitor
    // in real world situations, this will not be chosen randomly, but by specific answers and success
    function chooseRandomLimit(uint _bet) private view returns (uint){
        return addmod(_bet * block.timestamp, block.number * block.difficulty, _LIM);
    }

}
