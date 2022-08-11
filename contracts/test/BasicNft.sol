//SPX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
  //This is the sole nft here having below URI
  //i-whenever you mint you get same NFT
  //ii-you get the same URI on tokenURI
  //iii-diff tokenCounter depending on how many times same NFT

  event mintedNft(address sender, uint256 tokendId);

  string public constant TOKEN_URI =
    "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
  uint256 private s_tokenCounter;

  constructor() ERC721("Dogie", "GOG") {
    s_tokenCounter = 0;
  }

  function mintNft() public returns (uint256) {
    _safeMint(msg.sender, s_tokenCounter);
    s_tokenCounter += 1;
    emit mintedNft(msg.sender, s_tokenCounter);
    return s_tokenCounter;
  }

  function tokenURI(
    uint256 /* tokenId*/
  ) public pure override returns (string memory) {
    return TOKEN_URI;
  }

  function getTokenCounter() public view returns (uint256) {
    return s_tokenCounter;
  }
}
