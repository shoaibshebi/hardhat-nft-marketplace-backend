const { moveBlocks } = require("../utils/move-blocks");

const BLOCKS = 2;

async function mine() {
  await moveBlocks(BLOCKS);
}

mine()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

module.exports = {
  mine,
};
