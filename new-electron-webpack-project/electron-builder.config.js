const certificateSha1 = null; // REPLACE HERE
const signingHashAlgorithms = null; // REPLACE HERE

/** @type {import("electron-builder").Configuration} */
const builderOptions = {
  win: {
    certificateSha1,
    signingHashAlgorithms,
  },
};

module.exports = builderOptions;
