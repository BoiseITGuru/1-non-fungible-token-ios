const fcl = require("@onflow/fcl");

fcl.config({
  "app.detail.title": "1-NON-FUNGIBLE-TOKEN", // this adds a custom name to our wallet
  "app.detail.icon": "https://i.imgur.com/ux3lYB9.png", // this adds a custom image to our wallet
  "accessNode.api": process.env.ACCESS_NODE, // this is for the local emulator
  "discovery.wallet": process.env.WALLET, // this is for the local dev wallet
  "0xDeployer": process.env.CONTRACT_ADDRESS, // this auto configures `0xDeployer` to be replaced by the address in txs and scripts
  "0xStandard": process.env.STANDARD_ADDRESS,
});
