//File consists of with calling contract methods to do the stuff with blockchain
//like first get contract and then call contract function basicNft.mintNft()
const { ethers, network } = require("hardhat");
const { moveBlocks } = require("../utils/move-blocks");

const PRICE = ethers.utils.parseEther("0.1");

async function mintAndList() {
  const basicNft = await ethers.getContract("BasicNft");
  const nftMarketplace = await ethers.getContract("NftMarketplace");
  console.log("Minting...");
  const mintTx = await basicNft.mintNft();
  const mintTxReceipt = await mintTx.wait(1);
  const tokenId = mintTxReceipt.events[0].args.tokenId;

  console.log("Approving NFT...");
  //approve that specific tokenId NFT against this nftMarketplace's address
  const approvalTx = await basicNft.approve(nftMarketplace.address, tokenId);
  await approvalTx.wait(1);
  console.log("Listing NFT on marketplace...");
  //now this NFT will be listed on this
  const listTx = await nftMarketplace.listItem(
    basicNft.address,
    tokenId,
    PRICE
  );
  await listTx.wait(1);
  console.log("NFT Listed!");
  // if (network.config.chainId == 31337) {
  // Moralis has a hard time if you move more than 1 at once!
  console.log("Moving Blocks...");
  await moveBlocks(1, (sleepAmount = 1000));
  console.log("Moved!");
  // }
}

mintAndList()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
