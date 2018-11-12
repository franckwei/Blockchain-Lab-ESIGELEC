pragma solidity ^0.4.20;
contract MonToken {
/*This creates an array with all balances */
mapping (address => uint256) public balances;

string public name;
string public symbol;

event Transfer(address indexed from, address indexed to, uint256 value);

	/* Initializes contract with initial supply tokens to the creator of the contract */
constructor(uint256 initialBalance, string NomToken, string tokenSymbol) public {
    balances[msg.sender] = initialBalance;
    name = NomToken;
    symbol = tokenSymbol;
}
/*Send coins*/
function sendCoin(address receiver, uint256 amount) public returns (bool success){
/* Check if sender has balance and for
 overflows */
require(balances[msg.sender] >= amount);
require(balances[receiver] + amount>= balances[receiver]);
/* Add and subtract new balances */ balances[msg.sender] -= amount;
balances[receiver] += amount;
/* Notify anyone listening that this transfer took place */
emit Transfer(msg.sender, receiver, amount);
return true;
}
function getBalance(address addr) public view returns (uint){
return balances[addr];

}
}
