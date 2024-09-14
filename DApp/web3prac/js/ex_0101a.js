//promis와 then을 사용하여 계정 주소, 잔고, 거래 횟수를 출력해 본다

const { Web3 } = require('web3');
const url = 'http://127.0.0.1:8545'; //로컬 블록체인 네트워크

//web3 객체는 이더리움 네트워크와 통신하기 위한 객체
const web3 = new Web3(new Web3.providers.HttpProvider(url)); //web3 인스턴스 생성하여 블록체인 네트워크에 접속

let address;

const promise = web3.eth.getAccounts(); //네트워크에 연결된 모든 계정 주소 반환
promise.then(console.log); //비동기 실행 완료되면 결과 출력

address = '0xF8116DE05F3FaE0252beCE679327179C7c78bD8B'; //특정 게정의 잔고를 가져옴
web3.eth.getBalance(address).then(x => console.log(`Account balance is ${x} wei`));

//계정의 transaction 횟수 출력
web3.eth.getTransactionCount(address).then(x => console.log(`TX count ${x}`));

//비동기 실행 체인을 만들어본다
// for 루프를 사용하여 각 계정의 잔고를 가져오고 그 잔고를 console.log로 출력함
web3.eth.getAccounts().then(accounts => {
  for (const acc of accounts) {
    web3.eth.getBalance(acc).then(console.log);
  }
});
