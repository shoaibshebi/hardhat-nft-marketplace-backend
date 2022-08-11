//SPX-License-Identifier: MIT
//Contract will not hold the NFT, instead Owner will directly transfer the NFT
// , marketplace or contract will just approve it
// Renterency attack: always call the external function and fund transfer func at the end, and modify state variable before then

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error NftMarketplace__PriceMustBeAboveZero();
error NftMarketplace__NotApprovedForMarketplace();
error AlreadyListed(address nftAddress, uint256 tokenId);
error NftMarketplace__NotOwner();
error NftMarketplace__NotListed(address nftAddress, uint256 tokenId);
error PriceNotMet(address nftAddress, uint256 tokenId, uint256 price);
error NftMarketplace__NoProceeds();
error NftMarketplace__TransferFailed();

contract NftMarketplace {
  //events
  event ItemListed(
    address indexed seller,
    address indexed nftAddress,
    uint256 indexed tokenId,
    uint256 price
  );
  event ItemBought(
    address indexed sender,
    address indexed nftAddress,
    uint256 indexed tokenId,
    uint256 price
  );
  event ItemCanceled(
    address indexed sender,
    address indexed nftAddress,
    uint256 tokenId
  );

  //State variables
  struct Listing {
    uint256 price;
    address seller;
  }
  // nft address -> tokenid -> llisting
  mapping(address => mapping(uint256 => Listing)) private s_listings;
  //money poeple will earn on selling nft - seller -> money
  mapping(address => uint256) private s_proceeds;

  modifier notListed(
    address nftAddress,
    uint256 tokenId,
    address owner
  ) {
    Listing memory listing = s_listings[nftAddress][tokenId];
    if (listing.price > 0) {
      revert AlreadyListed(nftAddress, tokenId);
    }
    _;
  }
  modifier isOwner(
    address nftAddress,
    uint256 tokenId,
    address sender
  ) {
    IERC721 nft = IERC721(nftAddress);
    if (nft.ownerOf(tokenId) != sender) {
      revert NftMarketplace__NotOwner();
    }
    _;
  }
  modifier isListed(address nftAddress, uint256 tokenId) {
    Listing memory listing = s_listings[nftAddress][tokenId];
    if (listing.price <= 0) {
      revert NftMarketplace__NotListed(nftAddress, tokenId);
    }
    _;
  }

  //Initialization
  constructor() {}

  // /////////////
  // Main Fuctions
  // /////////////

  function listItem(
    address nftAddress,
    uint256 tokenId,
    uint256 price
  )
    external
    notListed(nftAddress, tokenId, msg.sender)
    isOwner(nftAddress, tokenId, msg.sender)
  {
    if (price <= 0) {
      revert NftMarketplace__PriceMustBeAboveZero();
    }

    //we will approve the nft's structure and behaiver from IERC721 standards,
    IERC721 nft = IERC721(nftAddress);
    //address(this)-refers to the address of the instance of the contract where the call is being made.
    if (nft.getApproved(tokenId) != address(this)) {
      revert NftMarketplace__NotApprovedForMarketplace();
    }
    s_listings[nftAddress][tokenId] = Listing(price, msg.sender);
    emit ItemListed(msg.sender, nftAddress, tokenId, price);
  }

  function buyItem(
    address nftAddress,
    uint256 tokenId,
    address
  )
    external
    payable
    //   nonReentrant
    isListed(nftAddress, tokenId)
  {
    Listing memory listedItem = s_listings[nftAddress][tokenId];
    if (msg.value < listedItem.price) {
      revert PriceNotMet(nftAddress, tokenId, listedItem.price);
    }
    //add up the seller amount
    s_proceeds[listedItem.seller] += msg.value;
    // Could just send the money...
    // https://fravoll.github.io/solidity-patterns/pull_over_push.html
    delete (s_listings[nftAddress][tokenId]);
    //We just sent the amount above, now This IERC721 transferFrom method will do stuff itself
    IERC721(nftAddress).transferFrom(listedItem.seller, msg.sender, tokenId);
    emit ItemBought(msg.sender, nftAddress, tokenId, listedItem.price);
  }

  function cancelListing(address nftAddress, uint256 tokenId)
    external
    isOwner(nftAddress, tokenId, msg.sender)
    isListed(nftAddress, tokenId)
  {
    delete (s_listings[nftAddress][tokenId]);
    emit ItemCanceled(msg.sender, nftAddress, tokenId);
  }

  function updateListing(
    address nftAddress,
    uint256 tokenId,
    uint256 newPrice
  )
    external
    isListed(nftAddress, tokenId)
    isOwner(nftAddress, tokenId, msg.sender)
  {
    s_listings[nftAddress][tokenId].price = newPrice;
    emit ItemListed(msg.sender, nftAddress, tokenId, newPrice);
  }

  function withdrawProceeds() external {
    uint256 proceeds = s_proceeds[msg.sender];
    if (proceeds <= 0) {
      revert NftMarketplace__NoProceeds();
    }
    s_proceeds[msg.sender] = 0;
    //transfer proceeds to the caller/withdrawer account
    (bool success, ) = payable(msg.sender).call{ value: proceeds }("");
    if (!success) {
      revert NftMarketplace__TransferFailed();
    }
  }

  function getListing(address nftAddress, uint256 tokenId)
    external
    view
    returns (Listing memory)
  {
    return s_listings[nftAddress][tokenId];
  }

  function getProceeds(address seller) external view returns (uint256) {
    return s_proceeds[seller];
  }
}
