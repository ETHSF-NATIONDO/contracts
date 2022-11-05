// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EndorseContract.sol";

contract EndorseContractTest is Test {
    EndorseContract public counter;
    function setUp() public {
       counter = new EndorseContract();
       counter.setNumber(0);
    }

    function testIncrement() public {
        counter.increment();
        counter.increment();
        counter.increment();

        assertEq(counter.number(), 3);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
