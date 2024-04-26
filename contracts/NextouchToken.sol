// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Define contract 
contract NexTouchToken is ERC20Capped, ERC20Burnable {
    address payable public owner;//this variable stores the address of the contract owner and allows them to receive Ether payments to that address.
    uint256 public blockReward;//This variable stores the amount of token reward awarded for mining. 

    constructor(uint256 cap, uint256 reward) ERC20("NexTouchToken", "NTK") ERC20Capped(cap * (10**decimals())) { 
        owner = payable(msg.sender);//Store the address of whoever deployed this contract (obtained from msg.sender) in the owner variable.  Also, make sure this address can receive Ether payments by converting it to a payable address.
        _mint(owner, 70000000 * (10 ** decimals())); //_mint is a function used to create (mint) new tokens and assign them to a specified address.
        //This mints (creates) 70,000,000 tokens (adjusted for decimals) and assigns them to the contract owner. The _mint function likely comes from the inherited ERC20 standard.
        blockReward = reward * (10 ** decimals());//set the block amount reward
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual {
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) {//check the valid address
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function _mintMinerReward() internal {//The internal keyword restricts this function's direct accessibility. It can only be called by other functions within the same contract. This helps control how and when miner rewards are minted.
        _mint(block.coinbase, blockReward);
    }
    
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
    
    function setBlockReward(uint256 reward) public {//setting the block reward
        blockReward = reward * (10 ** decimals());//amount the blockReward
    }

    modifier onlyOwner {
        require(msg.sender == owner, "only Owner can call this function");
        _;
    }//This modifier restricts access to functions within a smart contract. Only the contract's owner, as defined by the owner variable, can call functions decorated with this modifier.

    function _mint(address account, uint256 amount) internal virtual override(ERC20) {//this function overrides a virtual function from the inherited ERC20 standard
        require(totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
}
