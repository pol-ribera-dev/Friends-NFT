pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {friendsNFT} from "../src/FriendsNFT.sol";

contract Deploy is Script {
    function run() external returns (friendsNFT) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name_ = "Friends NFT";
        string memory symbol_ = "LOL";
        friendsNFT nft = new friendsNFT(name_, symbol_);

        vm.stopBroadcast();
        return nft;
    }
}
