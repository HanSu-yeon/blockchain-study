const fs = require("fs");
const contractABI = JSON.parse(
  fs.readFileSync("./build/contracts/MyERC721.json")
).abi;
require("dotenv").config();
const Web3 = require("web3");

const contractAddress = process.env.ERC721;
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
const contract = new web3.eth.Contract(contractABI, contractAddress);

async function getBalance(_account) {
  //https://web3js.readthedocs.io/en/v1.2.0/web3-eth-contract.html?highlight=call#id12
  const balance = await contract.methods.balanceOf(_account).call();

  console.log(`Balance of ${_account} is ${balance}`);
}

getBalance(process.env.PUBLIC_KEY);
