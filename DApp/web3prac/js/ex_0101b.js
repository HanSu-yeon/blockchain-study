// async와 await 사용하여 비동기적으로 계정 주소, 잔고, 거래 횟수를 출력해 본다

const { Web3 } = require('web3');
const url = 'http://127.0.0.1:8545';

const web3 = new Web3(url);

let accounts, balances, txcounts;

(async function () {
  accounts = await web3.eth.getAccounts();

  balances = [];
  txcounts = [];

  for (const acc of accounts) {
    let balance = await web3.eth.getBalance(acc);

    let txcount = await web3.eth.getTransactionCount(acc);
    balances.push(balance);
    txcounts.push(txcount);
  }

  for (const i in accounts) {
    console.log(`account = ${accounts[i]}, balance = ${web3.utils.fromWei(balances[i], 'ether')} ether, tx count = ${txcounts[i]}`);
  }
})();
