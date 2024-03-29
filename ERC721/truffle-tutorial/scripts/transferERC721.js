const fs = require("fs");
const contractABI = JSON.parse(
  fs.readFileSync("./build/contracts/MyERC721.json")
).abi;
require("dotenv").config();
const Web3 = require("web3");

const contractAddress = process.env.ERC721;
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
const contract = new web3.eth.Contract(contractABI, contractAddress);

async function transferERC721(_from, _to, _tokenId) {
  const signedTx = await web3.eth.accounts.signTransaction(
    {
      to: contractAddress,
      gas: 2000000,
      data: contract.methods
        .safeTransferFrom(_from, _to, _tokenId.toString())
        .encodeABI(),
    },
    process.env.PRIVATE_KEY
  );

  console.log(`signedTx >> ${signedTx.rawTransaction}`);

  await web3.eth
    .sendSignedTransaction(signedTx.rawTransaction.toString("hex"))
    .on("receipt", console.log);
}

transferERC721(process.env.PUBLIC_KEY, process.env.TEST_PUBLIC_KEY, 2);
