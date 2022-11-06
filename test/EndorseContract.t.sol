// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EndorseContract.sol";
import "../src/SBT.sol";
import "forge-std/console.sol";

contract EndorseContractTest is Test {
    EndorseContract public endorse;
    SBT public sbt;
    function setUp() public {
       endorse = new EndorseContract();
       vm.prank(address(endorse));
       sbt = new SBT("DORSE", "DORSE");
    }

    function testSBTIndex() public {
        assertEq(sbt.index(), 0);
    }

    function testSBTName() public {
        assertEq(sbt.name(), "DORSE");
    }

    function testSBTSymbol() public {
        assertEq(sbt.symbol(), "DORSE");
    }

    function testSetSBTAddress() public {
        address SBT_ADDRESS = address(sbt);
        endorse.setSBTAddress(SBT_ADDRESS);
        assertEq(endorse.SBT_ADDRESS(), SBT_ADDRESS);
    }

    function testFailSetSBTAddress() public {
        address SBT_ADDRESS = address(sbt);
        vm.prank(address(0x66544));
        endorse.setSBTAddress(SBT_ADDRESS);
        assertEq(endorse.SBT_ADDRESS(), SBT_ADDRESS);
    }

    function testEndorse() public {
        address SBT_ADDRESS = address(sbt);
        endorse.setSBTAddress(SBT_ADDRESS);

        address [] memory recipients = new address[](5);
        recipients[0] = address(0x0988888); 
        recipients[1] = address(0x7665544);
        recipients[2] = address(0x542344);
        recipients[3] = address(0x0988888);
        recipients[4] = address(0x542344);

        string [] memory datas = new string[](5);
        datas[0] = "one";
        datas[1] = "two";
        datas[2] = "three";
        datas[3] = "four";
        datas[4] = "five";

        endorse.endorse(recipients, datas);

        assertEq(endorse.uniqueRecommandations(address(0x0988888)), 2);
        assertEq(endorse.uniqueRecommandations(address(0x7665544)), 1);
        assertEq(endorse.uniqueRecommandations(address(0x542344)), 2);

        assertEq(sbt.index(), 5);
        assertEq(sbt.ownerOf(0), address(0x0988888));
        assertEq(sbt.ownerOf(1), address(0x7665544));
        assertEq(sbt.ownerOf(2), address(0x542344));
        assertEq(sbt.ownerOf(3), address(0x0988888));
        assertEq(sbt.ownerOf(4), address(0x542344));

        assertEq(sbt.tokenURI(0), "one");
        assertEq(sbt.tokenURI(1), "two");
        assertEq(sbt.tokenURI(2), "three");
        assertEq(sbt.tokenURI(3), "four");
        assertEq(sbt.tokenURI(4), "five");

        assertEq(sbt.balanceOf(address(0x0988888)), 2);
        assertEq(sbt.balanceOf(address(0x542344)), 2);
        assertEq(sbt.balanceOf(address(0x7665544)), 1);

        string[] memory array = endorse.getSBTsByAddress(address(0x0988888));
        assertEq(array.length, 2);
        assertEq(array[0], "one");
        assertEq(array[1], "four");
    }


}
