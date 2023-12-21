// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract AuthProviders is AccessControl {
    bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
    uint256 public tokenId;
    address public nftContract;  // Address of the ERC-721 token contract
    address public payee;
    bool public isReleased;

    constructor(address _nftContract, address _payee, uint256 _tokenId) {
        nftContract = _nftContract;
        tokenId = _tokenId;
        payee = _payee;
        isReleased = false;

        // Assuming you need to approve this contract to spend the NFT
        IERC721(nftContract).approve(address(this), _tokenId);
    }

    function releaseNFT() public {
        require(hasRole(MY_ROLE, msg.sender));
        isReleased = true;

        // Transfer ERC-721 token to the payee
        IERC721(nftContract).transferFrom(address(this), payee, tokenId);
    }
}
