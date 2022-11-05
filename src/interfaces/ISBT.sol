pragma solidity ^0.8.13;

interface ISBT {

    function mint(address beneficiary_, string calldata uri_) external {
    }

    function burn(uint256 tokenId_) external{
    }
}