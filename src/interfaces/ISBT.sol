pragma solidity ^0.8.13;

interface ISBT {

    function index() external view returns (uint256);

    function mint(address beneficiary_, string calldata uri_) external;

    function burn(uint256 tokenId_) external;

    function ownerOf(uint256 tokenId) external view returns (address);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}