// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC4973} from "./ERC4973.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


//Initializable, UUPSUpgradeable,

contract SBT is ERC4973, ReentrancyGuard {

    uint256 public index = 0;
    constructor(string memory name_, string memory symbol_) ERC4973(name_, symbol_, "1") {}

    function mint(address beneficiary_, string calldata uri_) external nonReentrant{
        _mint(msg.sender, beneficiary_, index, uri_);
        index += 1;
    }

    function burn(uint256 tokenId_) external nonReentrant{
        require(ownerOf(tokenId_) == msg.sender, "you re not the ow,ner of the token id");
        _burn(tokenId_);
    }

    //function initialize() public initializer
}