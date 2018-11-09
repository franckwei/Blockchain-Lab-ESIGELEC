pragma solidity ^0.4.18;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract MyToken is owned {
    mapping (address => uint256) public balanceOf;
    mapping (address => bool) public frozenAccount;

    string public name;
    string public symbol;
    uint8 public decimals;
    address public centralMinter;
    uint256 public totalSupply;
    uint256 public commission = 3;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozenFunds(address target, bool frozen);

    function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) public {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        if (centralMinter != 0) owner = centralMinter;

    }

    function transfer(address _to, uint256 _value) public {
        require(!frozenAccount[msg.sender]);
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] = balanceOf[msg.sender] - _value - commission;
        balanceOf[_to] = balanceOf[_to] + _value - commission;
        balanceOf[owner] += commission;
        Transfer(msg.sender, _to, _value);
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
      balanceOf[target] += mintedAmount;
      totalSupply += mintedAmount;
      Transfer(0, owner, mintedAmount);
      Transfer(owner, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
}
