// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {ISBT} from "./interfaces/ISBT.sol";

error NullRecipientNotAllowed();
error NullUriNotAllowed();
error SBTAddressNotSet();
error SizeIsWrong();
error SizeWrongGetterSBT();

contract EndorseContract is ReentrancyGuard, Ownable {

    // tracks the number of unique recommandations one's received
    mapping(address => uint) public uniqueRecommandations;

    mapping(address => mapping (string => uint256)) public referralsByOwnerBySkill;

    address public SBT_ADDRESS;

    constructor() {}


    function endorse(address[] memory recipients, string[] memory uris) external nonReentrant {
        if (SBT_ADDRESS == address(0)) {
            revert SBTAddressNotSet();
        }
        uint length = recipients.length;
        uint length2 = uris.length;

        if (length != length2) {
            revert SizeIsWrong();
        }
        for (uint i = 0 ; i < length ; ++i) {
            if (recipients[i] == address(0)) {
                revert NullRecipientNotAllowed();
            }
            uint256 txtLength = bytes(uris[i]).length;
            if (txtLength == 0) {
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
    //string[] memory result
    function getSBTsByAddress(address owner) external view returns(string[] memory) {
        uint256 amount = uniqueRecommandations[owner];
        uint256 currentSupply = ISBT(SBT_ADDRESS).index();
        uint256 j = 0;
        string[] memory res = new string[](amount);
        for (uint256 i=0; i < currentSupply ; ++i){
            if (ISBT(SBT_ADDRESS).ownerOf(i) == owner) {
                res[j] = ISBT(SBT_ADDRESS).tokenURI(i);
                j++;
            }
        }
        return res;
        /*if (j != amount) {
            revert SizeWrongGetterSBT();
        }*/
    }
}
