//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.24;

import { MerkleAirdrop, IERC20 } from "../../src/MerkleAirdrop.sol";
import { BG_Token } from "../../src/BG_Token.sol";
import { Script } from "forge-std/Script.sol";


contract DeployMerkleAirdrop is Script {
    bytes32 root = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 amountToTransfer = 4 * (25 *  1e18);

    function deployMerkleAirdrop () public returns (MerkleAirdrop, BG_Token){
        vm.startBroadcast();
        
        BG_Token token = new BG_Token();
        MerkleAirdrop airdrop = new MerkleAirdrop(token, root); 
        token.mint(token.owner(), amountToTransfer);  // Note: The tokens are minted to the owner not the contract
        IERC20(token).transfer(address(airdrop), amountToTransfer);

        vm.stopBroadcast();
        return (airdrop, token);
    }

    function run() external returns (MerkleAirdrop, BG_Token) {
        return deployMerkleAirdrop();
    }
}
