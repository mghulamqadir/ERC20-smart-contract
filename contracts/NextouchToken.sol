// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Define contract 
contract NexTouchToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward) ERC20("NexTouchToken", "NTK") ERC20Capped(cap * (10**decimals())) { 
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals())); //default decimal points are 18
        //message the sender with initialSupply
        blockReward = reward * (10 ** decimals());
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual {
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) {//check the valid address
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }
    
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
    
    function setBlockReward(uint256 reward) public {
        blockReward = reward * (10 ** decimals());
    }

    modifier onlyOwner {
        require(msg.sender == owner, "only Owner can call this function");
        _;
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20) {
        require(totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
}
