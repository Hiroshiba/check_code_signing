const certificateSha1 = null; // REPLACE HERE

/** @type {import("electron-builder").Configuration} */
const builderOptions = {
  win: {
    certificateSha1,
  },
};

module.exports = builderOptions;
