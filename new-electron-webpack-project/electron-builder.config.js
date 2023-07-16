const certificateSha1 = ""; // REPLACE HERE

/** @type {import("electron-builder").Configuration} */
const builderOptions = {
  win: {
    certificateSha1,
  },
};

module.exports = builderOptions;
