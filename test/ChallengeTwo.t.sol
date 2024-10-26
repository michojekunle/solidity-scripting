// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "../src/ChallengeTwo.sol";
import {Test, console2} from "forge-std/Test.sol";

contract ChallengeTwoTest is Test {
    ChallengeTwo chal;
    
    function setUp() public {
        chal = new ChallengeTwo();
    }
}