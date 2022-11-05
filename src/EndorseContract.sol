// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {ISBT} from "./interfaces/ISBT.sol";

error NullRecipientNotAllowed();
error NullUriNotAllowed();
error SBTAddressNotSet();
error SizeIsWrong();

contract EndorseContract is ReentrancyGuard, Ownable {

    // tracks the number of unique recommandations one's received
    mapping(address => uint) public uniqueRecommandations;

    mapping(address => mapping (string => uint256)) public referralsByOwnerBySkill;

    address public SBT_ADDRESS;

    constructor() {}


    function endorse(address[] recipients, string[] calldata uris) external nonReentrant {
        if (SBT_ADDRESS == address(0)) {
            revert SBTAddressNotSet();
        }
        uint length = recipient.length;
        uint length2 = uris.length;

        if (length != length2) {
            revert SizeIsWrong();
        }
        for (uint i = 0 ; i < length ; ++i) {
            if (recipient[i] == address(0)) {
                revert NullRecipientNotAllowed();
            }
            if (uris[i] == "") {
                revert NullUriNotAllowed();
            }
        }
        // mint SBT to msg.sender for each recipient,uri
        // address endorser = msg.sender;
        for (uint i=0; i < length ; ++i) {
            address rec = recipients[i];
            ISBT(SBT_ADDRESS).mint(rec, uris[i]);
            uniqueRecommandations[rec] += 1;
            // TODO : decode the uri to get skills 
        }

    }

    function setSBTAddress(address value_) external onlyOwner {
        SBT_ADDRESS = value_;
    }
}
