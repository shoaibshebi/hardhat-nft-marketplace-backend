const { network } = require("hardhat");

function sleep(timeInMs) {
  return new Promise((resolve) => setTimeout(resolve, timeInMs));
}

async function moveBlocks(amount, sleepAmount = 0) {
  console.log("Moving blocks...");
  for (let index = 0; index < amount; index++) {
    //making call to local blockchain to mine block - you cant do it for live
    await network.provider.request({
      method: "evm_mine",
      params: [],
    });
    if (sleepAmount) {
      console.log(`Sleeping for ${sleepAmount}`);
      await sleep(sleepAmount);
    }
  }
  console.log(`Moved ${amount} blocks`);
}

module.exports = {
  moveBlocks,
  sleep,
};
