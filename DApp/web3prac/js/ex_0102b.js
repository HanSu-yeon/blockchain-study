//async와 await 사용
const Tx = require('ethereumjs-tx').Transaction;
require('dotenv').config();
const { Web3 } = require('web3');
const url = 'http://127.0.0.1:8545';

const web3 = new Web3(url);

//2. 송금자, 수금자 주소 및 송금자의 개인키 설정
let addr_receiver, addr_sender, privatekeySender;

addr_sender = process.env.ADDR_SENDER;
privatekeySender = process.env.PRIVATEKEY_SENDER;
addr_receiver = process.env.ADDR_RECEIVER;

(async function () {
  try {
    let txCount = await web3.eth.getTransactionCount(addr_sender);

    let txObj = {
      nonce: web3.utils.toHex(txCount),
      from: addr_sender,
      to: addr_receiver,
      gasPrice: 10000000000, //가스 가격(Wei 단위)
      gas: 3000000, //가스 한도
      value: Number(web3.utils.toWei('1', 'ether')), //송금 금액. 여기서는 1이더를 Wei로 변환하여 사용
      data: '0x', //트랜잭션에 첨부할 데이터 없음
    };

    let tx = new Tx(txObj);
    tx.sign(Buffer.from(privatekeySender, 'hex'));

    let serializedTx = tx.serialize();

    let sentTX = await web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'));
    console.log('Success!');
    console.log(sentTX);
  } catch (err) {
    console.log(err.message);
  }
})();
