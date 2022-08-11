const { ethers } = require("hardhat");

const PRICE = ethers.utils.parseEther("0.1");

async function mintAndList() {
  const basicNft = await ethers.getContract("BasicNft");
  const nftMarketplace = await ethers.getContract("NftMarketplace");
  console.log("Minting...");
  const mintTx = await basicNft.mintNft();
  console.log("mintTx: ", mintTx);
  const mintTxReceipt = await mintTx.wait(1);
  console.log("mintTxReceipt: ", mintTxReceipt);
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
  console.log("Listed !");
}

mintAndList()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
