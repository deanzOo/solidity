/********************************************
            Compiler and License
            This must go at the start
            of any solidity file
******************************************* */
// SPDX-License-Identifier: MIT
//pragma solidity ^0.7.4;

/********************************************
                Comments
******************************************* */
// single line comment

/*
multi line
comment
*/

/**
natspec comment
used above function declarations
 */

/// second way for natspec comment


/********************************************
                Imports
******************************************* */
/* 

        * global import
    import "filename";

        * namespaced import
    import * as <name> from "filename";

        * specific names
    import {<name1> as <name>, <name2>} from "filename";

        * global to namespace
    import "filename" as <name>;

*/

/********************************************
                Types
******************************************* */
/*
    * string
        string var_name = "string content";
    * signed integer
        int var_name = -1;
    * unsigned integer
        uint var_name = 1;
    * boolean
        bool var_name = true;
    * address 
        address var_name = 0x02ba773b... => 20 byte value. size of an etherum address
        address payable var_name = ... => identical to address but comes with members: transfer and send
    * bytes
        bytes var_name = ...
*/

/********************************************
                Arrays
******************************************* */
/*
    string [] var_name;
 */

 /********************************************
                Structs
******************************************* */
/*
    struct var_name {
        int var_name;
        string var_name2;
    }
*/

 /********************************************
                Enums
******************************************* */
/*
    enum var_name {
        var_name,
        var_name2
    }
*/

 /********************************************
                Mappings
******************************************* */
/*
    * Similar to dictionaries from other languages
    mapping(address => uint) public var_name;
*/

 /********************************************
                Units
******************************************* */
/*
    * A literal number can take a suffix of
    
        * Ether Unit
                * wei
                * 500 finney = 1 ether
                * szabo
                * ether
        * Time Unit
                * seconds
                * minutes
                * hours
                * days
                * weeks
*/

 /********************************************
        Block and Transaction Properties
******************************************* */
/*
    * blockhash(uint blockNumber) returns (bytes32) - hash of the given block
    * block.coinbase returns (address payable) - current block miner's address
    * block.difficulty returns (uint)
    * block.gaslimit returns (uint)
    * block.number returns (uint)
    * block.timestamp
    * gasleft() returns (uint256)
    * msg.data returns (bytes calldata)
    * msg.sender returns (address payable)
    * msg.sig returns (bytes4)
    * msg.value returns (uint) - number of wei sent with the message
    * now returns (uint) - same as block.timestamp
    * tx.gasprice returns (uint) - gas price of the transaction
    * tx.origin returns (address payable) - sender of the transaction
*/

 /********************************************
                Functions
******************************************* */
/*
                                    
                                                
    function func_name(parameters) visibility_trait pure
        returns (parameters) {

    }

    parameters:
        type varname, type varname...

    visibility_trait -
        * public - from outside the contract
        * private - within the contract only
    
    pure -
        Only declare pure if
        A function that does not read nor modifies the state of the contract with:
            * Reading state variables
            * Accessing address(this).balance or <address>.balance
            * Accessing any of the special variable of block, tx, msg (msg.sig and msg.data can be read)
            * Calling any function not marked pure
            * Using inline assembly that contains certain opcodes
*/

 /********************************************
            Functions Modifiers
******************************************* */
/*
    Can be used to easily change the behaviour of functions
    Basicly a condition that needs to be met before the function can be run

    modifier modifier_name() {
        require (
            condition); // condition example: state_var_name >= 0
        _; // need to be the last line of a modifier to close the modifier
    }
    function func_name(parameters) public {
        ...
    }

*/

 /********************************************
                Operators
******************************************* */
/*
    * Arithmetics
        * +
        * -
        * *
        * /
        * %
        * **
    * Logical
        * !
        * &&
        * ||
        * ==
        * !=
    * Bitwise
        * &
        * |
        * ^
        * ~
        * >>
        * <<
*/

 /********************************************
                Control Flow
******************************************* */
/*
    * If - Else
    if (statement) {

    } else {

    }
    
    * While
    while (statement) {
        // code will run while condition is true
    }
    
    * do 
    do {
        // code will run until condition is false
    } while (statement)

    * For
    for (type varname = ..; statement; expression) {

    }
*/

 /********************************************
                State Variables
******************************************* */
/*
    Variables whose values are permanently stored in contract context
    any member of the contract is a state variable of the contract
    
    contract contract_name {
        type varname; // this is a state variable
    }
*/


/********************************************
               Events
******************************************* */
/*
    This is an interface abstraction of the logging system of the EVM - Ethereum Virtual Machine
    event event_name(parameters);
*/


/********************************************
           Object Oriented Shit
******************************************* */
/*
    Solidity offers oop shit such as inheritence, members, constructors, visibility, etc...
*/

/********************************************
               Example
******************************************* */
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Inheritance {
    address owner;
    bool deceased;
    uint money;

    constructor()public payable {
        owner = msg.sender;
        money = msg.value;
        deceased = false;
    }

    address [] wallets;
    mapping (address => uint)Inheritence;
}