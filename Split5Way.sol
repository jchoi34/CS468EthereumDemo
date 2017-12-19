pragma solidity ^0.4.0;
contract Split5Way {
    // global variables 
    address[] employees;
    uint totalReceived = 0;
    // dictionary; key, value pairs
    mapping (address => uint) withdrawnAmounts;
    
    // constructor, called when contract is first created
    function Split5Way() payable {
        updateTotalReceived();
    }
    
    // fallback function
    // executed when ether sent and no existing function called 
    function () payable{
        updateTotalReceived();
    }
    
    // update totalReceived when users pay in ether
    function updateTotalReceived() internal{
        totalReceived += msg.value;
    }
    
    // check if caller is employee
    // returns true or false
    modifier canWithdraw() {
        bool contains = false;
        
        for(uint i = 0; i < employees.length; i++){
            if(employees[i] == msg.sender){ // msg.sender = address caller
                contains = true;
            }
            // break not added so that same 
            // gas consumption fair
            // i.e., each employee must loop 5 times
            // so that every employee pays same gas price
        }
        require(contains);
        _;
    }
    
    // employee withdraw ether if canWithdraw == true
    // and if they have remaining balance
    function withdraw() canWithdraw{
        uint amountAllocated = totalReceived/employees.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;
        
        // if money allocated for employe greater than amount
        // they have withdrawn then allow them to withdraw
        if (amount > 0){
            msg.sender.transfer(amount);
        }
    }
}
