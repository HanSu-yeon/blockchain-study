const fs = require("fs");
const contractABI = JSON.parse(
  fs.readFileSync("./build/contracts/MyERC721.json")
).abi;
require("dotenv").config();
const Web3 = require("web3");

const contractAddress = process.env.ERC721;
const web3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545"));

//컨트랙트 인스턴스 생성
const contract = new web3.eth.Contract(contractABI, contractAddress);

//민팅 함수
async function mintERC721(_to, _tokenURI) {
  const signedTx = await web3.eth.accounts.signTransaction(
    {
      to: contractAddress,
      gas: 2000000,
      data: contract.methods.mintNFT(_to, _tokenURI).encodeABI(), //methods.myMethod.encodeABI
    },
    process.env.PRIVATE_KEY
  );

  console.log(`signedTx >> ${signedTx.rawTransaction}`);
  // web3.eth.accounts.signTransaction를 사용하여 생성된 이미 서명된 트랜잭션을 전송함
  await web3.eth
    .sendSignedTransaction(signedTx.rawTransaction.toString("hex"))
    .on("receipt", console.log);
}

mintERC721(process.env.PUBLIC_KEY, process.env.TOKEN_URI);
