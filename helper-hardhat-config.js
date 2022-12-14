// const networkConfig = {
//   default: {
//     name: "hardhat",
//     keepersUpdateInterval: "30",
//     subscriptionId: "588",
//     gasLane:
//       "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc",
//     interval: "30",
//     raffleEntranceFee: "10000000000000000",
//     callbackGasLimit: "500000",
//   },
//   31337: {
//     name: "localhost",
//     ethUsdPriceFeed: "0x9326BFA02ADD2366b30bacB125260Af641031331",
//     subscriptionId: "588",
//     gasLane:
//       "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", // 30 gwei
//     interval: "30",
//     raffleEntranceFee: "10000000000000000",
//     mintFee: "100000000000000000", // 0.1 ETH
//     callbackGasLimit: "500000", // 500,000 gas
//   },
//   // Price Feed Address, values can be obtained at https://docs.chain.link/docs/reference-contracts
//   // Default one is ETH/USD contract on Kovan
//   4: {
//     name: "rinkeby",
//     ethUsdPriceFeed: "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",
//     gasLane:
//       "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc",
//     callbackGasLimit: "500000", // 500,000 gas
//     mintFee: "10000000000000000", // 0.01 ETH
//     subscriptionId: "8807", // add your ID here!
//   },
//   5: {
//     name: "goerli",
//     ethUsdPriceFeed: "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e",
//     gasLane:
//       "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15",
//     callbackGasLimit: "500000", // 500,000 gas
//     mintFee: "10000000000000000", // 0.01 ETH
//     subscriptionId: "8807", // add your ID here!
//   },
// };

const DECIMALS = "18";
const INITIAL_PRICE = "200000000000000000000";
const VERIFICATION_BLOCK_CONFIRMATIONS = 6;
const developmentChains = ["hardhat", "localhost"];

const frontEndContractsFile =
  "../nextjs-nft-marketplace-moralis-fcc/constants/networkMapping.json";
const frontEndAbiLocation = "../nextjs-nft-marketplace-moralis-fcc/constants/";

module.exports = {
  VERIFICATION_BLOCK_CONFIRMATIONS,
  frontEndContractsFile,
  frontEndAbiLocation,
  // networkConfig,
  developmentChains,
  DECIMALS,
  INITIAL_PRICE,
};
