// 송금 트랜잭션을 생성하고 서명한 후, 블록체인 네트워크로 보내는 과정
//promise, then 패턴 사용
//1. 라이브러리 임포트 및 설정
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

//3. 트랜잭션 카운트(txCount) 조회 -> Nonce로 사용되어 트랜잭션의 순서를 지정함
web3.eth.getTransactionCount(addr_sender).then(txCount => {
  //4. 트랜잭션 객체 생성(txObj)
  let txObj = {
    nonce: web3.utils.toHex(txCount), //Nonce값(계정의 트랜잭션 카운트)
    from: addr_sender,
    to: addr_receiver,
    gasPrice: 10000000000, //가스 가격(Wei 단위)
    gas: 3000000, //가스 한도
    value: Number(web3.utils.toWei('1', 'ether')), //송금 금액. 여기서는 1이더를 Wei로 변환하여 사용
    data: '0x', //트랜잭션에 첨부할 데이터 없음
  };
  //5. 트랜잭션 서명 및 직렬화
  let tx = new Tx(txObj); //트랜잭션 객체 생성 후
  tx.sign(Buffer.from(privatekeySender, 'hex')); //송금자의 개인키로 트랜잭션 서명 (이때 개인키 Buffer로 변환하여 사용됨)
  let serializedTx = tx.serialize(); //트랜잭션 직렬화
  console.log("serializedTx.toString('hex')  ", serializedTx.toString('hex')); //직렬화된 트랜잭션을 16진수로 출력

  //6. 서명된 트랜잭션 네트워크로 전파
  let sentTX = web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'));
  sentTX.on('receipt', receipt => {
    //트랜잭션이 성공적으로 전파되면 receipt을 반환
    console.log('Success: ', receipt);
  });
  sentTX.on('error', err => {
    console.log(err.message);
  });
});
