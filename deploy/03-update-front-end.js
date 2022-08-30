const {
  frontEndContractsFile,
  frontEndAbiLocation,
} = require("../helper-hardhat-config");
require("dotenv").config();
const fs = require("fs");
const { network, ethers } = require("hardhat");

module.exports = async () => {
  if (process.env.UPDATE_FRONT_END) {
    console.log("Writing to front end...");
    await updateContractAddresses();
    await updateAbi();
    console.log("Front end written!");
  }
};

async function updateAbi() {
  const nftMarketplace = await ethers.getContract("NftMarketplace");
  const basicNft = await ethers.getContract("BasicNft");
  fs.writeFileSync(
    `${frontEndAbiLocation}NftMarketplace.json`,
    //do formate the nftMarkeplace contracts interface/abi code into ethers.utils.FormatTypes.json format
    nftMarketplace.interface.format(ethers.utils.FormatTypes.json)
  );
  fs.writeFileSync(
    `${frontEndAbiLocation}BasicNft.json`,
    basicNft.interface.format(ethers.utils.FormatTypes.json)
  );
}

async function updateContractAddresses() {
  const chainId = network.config.chainId.toString();
  const nftMarketplace = await ethers.getContract("NftMarketplace");
  const basicNFt = await ethers.getContract("BasicNft");
  const contractAddresses = JSON.parse(
    fs.readFileSync(frontEndContractsFile, "utf8")
  );
  if (chainId in contractAddresses) {
    if (
      !contractAddresses[chainId]["contracts"]["NftMarketplace"].includes(
        nftMarketplace.address
      )
    ) {
      contractAddresses[chainId]["contracts"]["NftMarketplace"].push(
        nftMarketplace.address
      );
    }
    if (
      !contractAddresses[chainId]["contracts"]["Nft"].includes(basicNFt.address)
    ) {
      contractAddresses[chainId]["contracts"]["Nft"].push(basicNFt.address);
    }
  } else {
    contractAddresses[chainId]["contracts"] = {
      NftMarketplace: [nftMarketplace.address],
      Nft: [basicNFt.address],
    };
  }
  fs.writeFileSync(frontEndContractsFile, JSON.stringify(contractAddresses));
}
module.exports.tags = ["all", "frontend"];
