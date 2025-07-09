// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IyamegeIdentityNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId = 1;
    mapping(address => bool) public hasMinted;

    constructor() ERC721("Iyamege Identity", "IYAID") {}

    function mintIdentity(string memory tokenURI) external {
        require(!hasMinted[msg.sender], "Already claimed");
        _mint(msg.sender, nextTokenId);
        _setTokenURI(nextTokenId, tokenURI);
        hasMinted[msg.sender] = true;
        nextTokenId++;
    }
}
