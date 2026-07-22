// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.24;

/*
    @title FriendsNFT

    @notice This contract allows the deployer to create NFTs (soulbound) for their friends in order to identify and verify them.
            Each NFT contains the following data:
            - Name
            - Image
            - Relationship
            - Nickname

    @dev This contract is based on ERC721.
         To keep the metadata and images decentralized and accessible on-chain,
         Pinata/IPFS is used for image storage.
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract friendsNFT is ERC721, Ownable {
    // DATA

    /// @dev Maps a token ID to its associated metadata.
    mapping(uint256 => TokenData) public IdToData;

    /// @dev Structure containing the NFT metadata.
    struct TokenData {
        string name;
        string image;
        string who;
        string title;
    }

    /// @dev Current amount of minted tokens.
    ///      The next token minted will use this ID.
    uint256 public id;

    // CONSTRUCTOR

    /// @dev Inicializate the contract, the owner is the deployer
    /// @param name_  Name of the ERC721 token
    /// @param symbol_ Symbol of the ERC721 token
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable(msg.sender) {}

    // EVENT

    /// @notice Emitted when a new NFT is minted.
    /// @param userAddress_ Address receiving the NFT.
    /// @param tokenId_ ID of the minted token.
    event MintNFT(address userAddress_, uint256 tokenId_);

    // EXTERNAL FUNCTIONS

    /// @dev Disables transfers because the NFT is soulbound.
    function transferFrom(address, address, uint256) public pure override {
        revert("Soulbound");
    }

    /// @dev Disables safe transfers with data because the NFT is soulbound.
    function safeTransferFrom(address, address, uint256, bytes memory) public pure override {
        revert("Soulbound");
    }

    /// @dev Allows the owner to mint a new NFT.
    /// @param _address Address that will receive the NFT.
    /// @param _name Name associated with the NFT.
    /// @param _image IPFS CID of the NFT image.
    /// @param _who Relationship with the NFT owner.
    /// @param _title Nickname or special title of the friend.
    /// Emits a {MintNFT} event.
    function createNFT(
        address _address,
        string memory _name,
        string memory _image,
        string memory _who,
        string memory _title
    ) external onlyOwner {
        IdToData[id] = TokenData(_name, _image, _who, _title);
        _safeMint(_address, id);
        emit MintNFT(_address, id);
        id++;
    }

    /// @dev Overrides the tokenURI(uint256 tokenId) function to return the metadata associated with the given token ID, stored in the `idToData` mapping.
    /// @param tokenId Token ID to query.
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);
        TokenData memory data = IdToData[tokenId];

        string memory json = string(
            abi.encodePacked(
                '{"name": "',
                data.name,
                '",',
                '"description": "Pols Friend ",',
                '"image": "ipfs://',
                data.image,
                '",',
                '"attributes": [{"trait_type": "Relationship", "value": "',
                data.who,
                '"},',
                '{"trait_type": "Achievement", "value": "',
                data.title,
                '"}]}'
            )
        );

        string memory encoded = Base64.encode(bytes(json));

        return string(abi.encodePacked("data:application/json;base64,", encoded));
    }
}
