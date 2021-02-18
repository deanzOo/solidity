// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Project {
    uint start;
    uint expiration;
    address [] competitors;
    uint256 [] Scores;
    uint [] Submissions;

    uint _LIM = 17;

    constructor(uint _daysActive) {
        start = block.timestamp;
        expiration = start + _daysActive * 1 days;
    }

    function getCompetitors() public view returns (address [] memory) {
        int l = int(competitors.length);
        address [l] memory comp_copy;
        for (uint i = 0; i < competitors.length; i++)
            comp_copy[i] = competitors[i];
        return comp_copy;
    }
    function getScores() public view returns (uint256 [] memory) {
        int l = int(Scores.length);
        uint256 [l] memory scores_copy;
        for (uint i = 0; i < Scores.length; i++)
            scores_copy[i] = Scores[i];
        return scores_copy;
    }
    function getSubmissions() public view returns (uint [] memory) {
        int l = int(Submissions.length);
        uint [l] memory submissions_copy;
        for (uint i = 0; i < Submissions.length; i++)
            submissions_copy[i] = Submissions[i];
        return submissions_copy;
    }

    // public endpoint for all competitors to submit their bets
    function bet(uint _answer) public {
        if (!expired()) {
            uint index = init_competitor(msg.sender);
            if (Submissions[index] < 3) {
                Submissions[index] += 1;
                Scores[index] = random_gas_use(_answer);
            }
        }
    }

    function getWinner() public returns (address){
        if (expired()) {
            uint256 max = 0;
            uint maxIndex = 0;
            for (uint i = 0; i < Scores.length; i++) {
                if (Scores[i] > max)
                    maxIndex = i;
            }
            return competitors[maxIndex];
        }
        return address(0);
    }

    function expired() public view returns (bool) {
        return block.timestamp > expiration;
    }

    function expire() public {
        expiration = 0;
    }

    // use gas randomly based on _limit_base
    function random_gas_use(uint _limit_base) public view returns (uint256)
    {
        uint limit = chooseRandomLimit(_limit_base);
        uint256 old_gas_used = gasleft();
        uint fix = 0;
        for (uint i = 0; i < limit; i++) {
            fix += mulmod(block.difficulty, block.timestamp, limit);
        }
        return old_gas_used - gasleft();
    }

    /*******************************************************************************
                                   Helper Functions
    *********************************************************************************/
    // simple way of checking if competitor already submitted or not
    function is_competitor(address _sender) public view returns (int) {
        for (uint i = 0; i < competitors.length; i++)
            if (competitors[uint(i)] == _sender)
                return int(i);
        return -1;
    }

    // if it's first submission for the competitor, lets enter him into the data base
    function init_competitor(address _sender) public returns (uint){
        int index = is_competitor(_sender);
        if (index == -1) {
            Scores.push(0);
            Submissions.push(0);
            competitors.push(_sender);
            return uint(competitors.length - 1);
        }

        return uint(index);
    }

    // some random way of choosing a scoring for the competitor
    // in real world situations, this will not be chosen randomly, but by specific answers and success
    function chooseRandomLimit(uint _bet) private view returns (uint){
        return _bet % _LIM;
    }

}
