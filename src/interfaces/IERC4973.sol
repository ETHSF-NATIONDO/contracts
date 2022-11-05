pragma solidity ^0.8.13;

interface IERC4973 {
    event Transfer (
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    function balanceOf(address owner) external view returns(uint256);

    function ownerOf(uint256 tokenId) external view returns(address);

    function unequip(uint256 tokenId) external;

    function give(
        address to,
        string calldata uri,
        bytes calldata signature
    ) external returns (uint256);

    function take(
        address from,
        string calldata uri,
        bytes calldata signature
    ) external returns (uint256);
}