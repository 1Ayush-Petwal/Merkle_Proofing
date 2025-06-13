// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    // allow only those addresses that are eligible for the airdrop
    // represented by the merkle node, to claim the airdrop

    error MerkleAirdrop__InvalidProof();
    error MerkleAirDrop__AlreadyClaimed();

    address [] claimers;
    IERC20 public immutable i_airdroptoken;
    bytes32 public immutable i_merkleRoot;

    // Track the users that have claimed the tokens already ( similar to the nullifier tree)
    // Prevent the double spend problem
    mapping (address => bool) private s_hasClaimed; // Storage variable 


    event Claimed(address account, uint256 amount);

    // Initing the token and the merkleRoot
    constructor(IERC20 _token, bytes32 _merkleRoot) {
        i_airdroptoken = _token;
        i_merkleRoot = _merkleRoot;
    } 

    // Claim for merkle nodes
    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {

        if(s_hasClaimed[account]){
            revert MerkleAirDrop__AlreadyClaimed();
        }

        // 1. Getting the leaf node that the account and amount hash up to
        // Preventing possible collisions that might occur 
        // this kind of attack is called 'second pre-image attack'        
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        // 2. Checking if the leaf is acutually in the merkle tree or not !! (Using the set of proves that we have merkleProof )
        if(!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)){
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;       
        // 3. Emit the event claimed to the EVM 
        emit Claimed(account, amount);

        // 4. Transfer the tokens to the account
        // To safeTransfer to the account just in case the account does not accept the ERC20 token, to delegate the error checking
        i_airdroptoken.safeTransfer(account, amount);  
            
    }
}