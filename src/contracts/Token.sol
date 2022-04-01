//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Token {

    using SafeMath for uint;
    //variables
    string public name = "DApp TOken";
    string public symbol = "DAPP";
    uint256 public decimals = 18;
    uint256 public totalSupply;


    //we have a class that is map to database table and attribute of that class map to columns
    //of database table 


//this smart contract store infromation and implement behavious so incase of balances 
//that really for storing information ,storing how many token someone owns

    //Track balances
    //we can track the balances like this 
    mapping(address => uint256) public balanceOf; //this will do two thing ,first 
    //it will create state variable and also expose balanceOF function
    //Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    //inorder to track balance , we need to store the balances=> state
    
    //send tokens => deduct the balance from one account and add it to another account


    constructor()  {
        totalSupply = 1000000 * (10 ** decimals);
        balanceOf[msg.sender] = totalSupply;
        //msg.sender is key that means person who deploy the smart contract .
        //smartcontract has some global varibale and one of them is msg 
        
    }

    //send tokens
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to !=address(0));
        require(balanceOf[msg.sender]>= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;

    }
}