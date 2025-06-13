// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {BG_Token} from "../../src/BG_Token.sol";
import {Test} from "forge-std/Test.sol";
import { DeployMerkleAirdrop } from "../../script/DeployMerkleAirdrop.s.sol";
import { ZkSyncChainChecker } from "foundry-devops/ZkSyncChainChecker.sol";
import {console} from "forge-std/console.sol";


contract MerkleAirdropTest is ZkSyncChainChecker, Test {
    MerkleAirdrop airdrop;
    BG_Token token;
    bytes32 merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    address user;
    uint256 userPrivKey;
    uint256 amountToCollect = (25 * 1e18); // 25.000000
    uint256 amountToSend = amountToCollect * 4;

    bytes32 proof1 = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proof2 = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576; 
    bytes32[] PROOF = [proof1, proof2];
    function setUp() public {
        if (!isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop, token) = deployer.deployMerkleAirdrop();
        }
        else {   

        token = new BG_Token();
        airdrop = new MerkleAirdrop(token, merkleRoot);
        
        // Mint tokens to the airdrop contract
        token.mint(address(this), amountToSend);
        token.transfer(address(airdrop), amountToSend);

        }

        (user, userPrivKey) = makeAddrAndKey("user");
    }

    function testUsersClaimToken() public {
        // Getting the starting balance of the user
        uint256 startingTokenBalance = token.balanceOf(user);
        
        vm.prank(user);
        // Make the airDrop 
        airdrop.claim(user, amountToCollect, PROOF);
        // Check if the user got the tokens or not 
        uint256 endingBalance = token.balanceOf(user);
        console.log("Ending balance", endingBalance);
        assertEq(endingBalance - startingTokenBalance, amountToCollect);
    }
} 
