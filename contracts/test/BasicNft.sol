//SPX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract BasicNft is ERC721 {
  //This is the sole nft here having below URI
  //i-whenever you mint you get same NFT
  //ii-you get the same URI on tokenURI
  //iii-diff tokenCounter depending on how many times same NFT

  event NftMinted(uint256 tokenId);

  uint256 private s_tokenCounter;
  mapping(uint256 => string) private s_tokenToUri;

  constructor() ERC721("Nft", "NFT") {
    s_tokenCounter = 0;
  }

  function mintNft(string memory nftHash) public returns (uint256) {
    s_tokenToUri[s_tokenCounter] = nftHash;
    _safeMint(msg.sender, s_tokenCounter);
    emit NftMinted(s_tokenCounter);
    uint256 tokenNo = s_tokenCounter;
    s_tokenCounter = s_tokenCounter + 1;
    return tokenNo;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    return s_tokenToUri[tokenId];
  }

  function getTokenCounter() public view returns (uint256) {
    return s_tokenCounter;
  }

  fallback() external payable {
    console.log("----- fallback:", msg.value);
  }

  receive() external payable {
    console.log("----- receive:", msg.value);
  }
}
