// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {NFT} from "../src/NFT.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        NFT nft = new NFT("NFT_tutorial", "TUT", "baseUri");

        vm.stopBroadcast();
    }
}

// forge script script/NFT.s.sol --rpc-url https://sepolia.infura.io/v3/470bde729ff64363bedec5afe71f8d66 --account other_acc_pkey  --sender 0xA711CEA2F1c571BbEEaB06Efd7dA8c660E7D6eA3 --broadcast -vvvvv
