// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Credential is ERC721URIStorage {
    uint256 private _nextTokenId;

    constructor() ERC721("Credential", "CRED") {}

    function licenseStudent(address student, string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 tokenId = _nextTokenId++;
        _mint(student, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }
}