# FriendsNFT 

FriendsNFT is a Solidity smart contract project that allows the creation of Soulbound NFTs (non-transferable NFTs) designed to work as a digital Friendship Card.

The main goal of the project is to uniquely identify my friends through personalized NFTs stored on the blockchain.
Nowadays, identity theft and impersonation are common problems on the internet, and this system provides a verifiable and permanent digital identity inside the blockchain ecosystem.

Additionally, having all friends grouped under the same NFT collection makes it easier to manage a private community and grant access to future projects, utilities, events, or exclusive experiences.

## How to use it:
All the code for this project is contained in the [FriendsNFT.sol](https://github.com/pol-ribera-dev/Friends-NFT/blob/main/src/FriendsNFT.sol) file.

Notice that only the account that deployed the contract is authorized to mint NFTs. Each NFT collection is personal, since everyone has their own friends. Therefore, the first step is to deploy your own contract with the collection name and symbol of your choice.

Minting an NFT is very straightforward. Simply call the contract's createNFT() function with the following parameters:
1. **Recipient address** - Wallet address of your friend
2. **Name associated with the NFT** - Name of your friend
3. **IPFS CID of the NFT image**- Image of your friend
4. **The relationship with the NFT owner** - A title for your friendship
5. **Nickname or special title** - Nickname of your firend

The recipient does not need to perform any action. Once the NFT is minted, it is automatically transferred to their wallet.

To store and obtain the IPFS CIDs for my NFT images, I used [Pinata](https://pinata.cloud/), which provides reliable and persistent IPFS pinning.

## Testing
All functions in the protocol have [tests](https://github.com/pol-ribera-dev/Friends-NFT/blob/main/test/friendsNFTTest.t.sol) implemented. To execute these tests:

```bash
forge test
```

The code has a 100% test coverage, you can check it by executing:

```bash
forge coverage
```

```bash
| File                | % Lines         | % Statements    | % Branches    | % Funcs       |
+=========================================================================================+
| src/FriendsNFT.sol  | 100.00% (15/15) | 100.00% (12/12) | 100.00% (0/0) | 100.00% (4/4) |

```

## Contract addresses
The contract has been deployed with this [script](https://github.com/pol-ribera-dev/Friends-NFT/blob/main/script/deploy.s.sol) on Arbitrum network in the next address: `0x867D1Ca9E55785E3388afF381691a7C481FBA39B` [ARBISCAN](https://arbiscan.io/address/0x867D1Ca9E55785E3388afF381691a7C481FBA39B)

Check a NFT example [here](https://opensea.io/item/arbitrum/0x867d1ca9e55785e3388aff381691a7c481fba39b/0)
