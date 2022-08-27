//SPX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
  //This is the sole nft here having below URI
  //i-whenever you mint you get same NFT
  //ii-you get the same URI on tokenURI
  //iii-diff tokenCounter depending on how many times same NFT

  event DogMinted(uint256 tokenId);

  // string public constant TOKEN_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
  string public constant TOKEN_URI =
    "ipfs://bafybeid3nhfrv6t6w4j7dmdrx65jsjbll23svohqbpjnegqsf5e37gcvmu/?filename=0-Monkey.json";
  uint256 private s_tokenCounter;

  constructor() ERC721("Dogie", "GOG") {
    s_tokenCounter = 0;
  }

  function mintNft() public {
    _safeMint(msg.sender, s_tokenCounter);
    emit DogMinted(s_tokenCounter);
    s_tokenCounter = s_tokenCounter + 1;
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
    return TOKEN_URI;
  }

  function getTokenCounter() public view returns (uint256) {
    return s_tokenCounter;
  }
}
