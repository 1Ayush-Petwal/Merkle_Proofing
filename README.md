## Merkle Proofing 

**Merkle Tree is cryptographic data - structure that have hashes in the nodes of the tree**

Each node of the tree is a hash, the parents are the hashing of the children nodes !!! 

## What is Merkle Proof ?

It is a way of proving that a certain data is inside a certain data group using the hashing mechanism. 

Here if we needed to prove that the hash1 was a part of the tree all we need to do is have the rest of the leave node hashes 2, 3, 4,.

Assume that the hash1 was in the tree, Now recursively hash the child to get the parent till we reach the root hash.

Root hash then can be compared with the expected root hash. If they are equal then our assumption that the hash1 is in the tree

How is it safe, security?

Since hashes are such that they are unique for all the nodes in the tree therefore it provides us with the proof


## Major Use Cases:

-   Proving smart contract state changes  such as in rollups.
-   Air-drops nodes in the merkle tree represent the wallet addresses that are supposed to get the airdrop
