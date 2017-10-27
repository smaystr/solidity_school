pragma solidity ^0.4.10;

contract OffChainLending {
    address lender;
    uint balanceLimit;
    mapping (address => uint) private balances;

    event lenderSent(address key, uint amount);
    event borroverSent(address key, uint amount);
    
    function OffChainLending(uint _balanceLimit) public {
        lender = msg.sender;
        balanceLimit = _balanceLimit;
    }
    
    modifier onlyByLender() {
        require(msg.sender == lender);
        _;
    }
    
    function setBalance(address key, uint amount) private {
        if (amount == 0) revert();
        
        if ((msg.sender == lender) && (balances[key] >= amount)) {
            balances[key] -= amount;
        } else if (balanceLimit - balances[key] > amount) {
            balances[key] += amount;
        }
        
    }

    function getBalance(address key) public constant returns (uint) {
        return balances[key];
    }

    function borroverLand(uint amount) public {
        setBalance(msg.sender, amount);
        borroverSent(msg.sender, amount);
    }
    
    function loanRepayment(address key, uint amount) public onlyByLender() {
        setBalance(key, amount);
        lenderSent(key, amount);
     }
}
