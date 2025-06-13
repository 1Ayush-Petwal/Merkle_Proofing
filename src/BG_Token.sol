// SPDX-License-Identifer: MIT 
pragma solidity ^0.8.24;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol"; 

contract BG_Token is ERC20, Ownable {

    constructor() ERC20("Bg_token","BG_TOKEN") Ownable(msg.sender) {} 
    
    
    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to, amount);
    }
}