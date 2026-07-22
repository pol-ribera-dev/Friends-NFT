// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "../src/friendsNFT.sol";

// Test of FriendsNFT.sol with 100% coverage

contract FriendsNFTTest is Test {
    friendsNFT nft;

    address owner = address(1);
    address user = address(2);

    string name_ = "Friends NFT";
    string symbol_ = "LOL";

    string tokenName = "test";
    string cidImage = "bafybeichlnhblt75zxgumkzeaenmt43kr5ailshrbyk5xm5vhcf3qncyre";
    string who = "best friend";
    string title = "GOD";

    function setUp() public {
        vm.prank(owner);
        nft = new friendsNFT(name_, symbol_);
    }

    function testDeployCorrect() public {
        assertEq(nft.owner(), owner);
        assertEq(nft.name(), name_);
        assertEq(nft.symbol(), symbol_);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(user);
        vm.expectRevert();
        nft.createNFT(user, tokenName, cidImage, who, title);
    }

    function testOwnerCanMint() public {
        vm.prank(owner);
        nft.createNFT(user, tokenName, cidImage, who, title);
        assertEq(nft.ownerOf(0), user);
    }

    function testCorrectData() public {
        vm.prank(owner);
        nft.createNFT(user, tokenName, cidImage, who, title);

        string memory base64 =
            "data:application/json;base64,eyJuYW1lIjogInRlc3QiLCJkZXNjcmlwdGlvbiI6ICJQb2xzIEZyaWVuZCAiLCJpbWFnZSI6ICJpcGZzOi8vYmFmeWJlaWNobG5oYmx0NzV6eGd1bWt6ZWFlbm10NDNrcjVhaWxzaHJieWs1eG01dmhjZjNxbmN5cmUiLCJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJSZWxhdGlvbnNoaXAiLCAidmFsdWUiOiAiYmVzdCBmcmllbmQifSx7InRyYWl0X3R5cGUiOiAiQWNoaWV2ZW1lbnQiLCAidmFsdWUiOiAiR09EIn1dfQ==";
        /* Is base64 of:
            {"name": "test","description": "Pols Friend ","image": "ipfs://bafybeichlnhblt75zxgumkzeaenmt43kr5ailshrbyk5xm5vhcf3qncyre","attributes": [{"trait_type": "Relationship", "value": "best friend"},{"trait_type": "Achievement", "value": "GOD"}]}
        */
        assertEq(nft.tokenURI(0), base64);
    }

    function testTwoMindCorrect() public {
        vm.startPrank(owner);

        uint256 firstId = nft.id();

        nft.createNFT(user, tokenName, cidImage, who, title);

        uint256 secondId = nft.id();

        nft.createNFT(user, tokenName, cidImage, who, title);

        assertEq(nft.ownerOf(firstId), user);
        assertEq(nft.ownerOf(secondId), user);
        assertTrue(firstId != secondId);
        assertEq(nft.balanceOf(user), 2);

        vm.stopPrank();
    }

    function testTransferFromReverts() public {
        vm.prank(owner);
        nft.createNFT(user, tokenName, cidImage, who, title);

        vm.prank(user);
        vm.expectRevert("Soulbound");
        nft.transferFrom(user, owner, 0);
    }

    function testSafeTransferFromWithDataReverts() public {
        vm.prank(owner);
        nft.createNFT(user, tokenName, cidImage, who, title);

        vm.prank(user);
        vm.expectRevert("Soulbound");
        nft.safeTransferFrom(user, owner, 0, "");
    }

    function testSafeTransferFromWithoutDataReverts() public {
        vm.prank(owner);
        nft.createNFT(user, tokenName, cidImage, who, title);

        vm.prank(user);
        vm.expectRevert("Soulbound");
        nft.safeTransferFrom(user, owner, 0);
    }

    function testMintToZeroAddressReverts() public {
        vm.prank(owner);
        vm.expectRevert();
        nft.createNFT(address(0), tokenName, cidImage, who, title);
    }

    function testEmptyStringsCorrect() public {
        vm.prank(owner);
        nft.createNFT(user, "", "", "", "");

        string memory uri = nft.tokenURI(0);
        assertTrue(bytes(uri).length > 0);
    }
}
