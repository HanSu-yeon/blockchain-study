//async와 await 사용
const { Web3 } = require('web3');
const url = 'http://127.0.0.1:8545';

const web3 = new Web3(new Web3.providers.HttpProvider(url));

let contarctABI = [
  {
    inputs: [
      {
        internalType: 'uint256',
        name: 'x',
        type: 'uint256',
      },
    ],
    name: 'set',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [],
    name: 'get',
    outputs: [
      {
        internalType: 'uint256',
        name: '',
        type: 'uint256',
      },
    ],
    stateMutability: 'view',
    type: 'function',
  },
];

let contractAddress = '0x1852C00a5A728F6e1bB460b15906cB7f928E75da';
let sendAddress = '0xF8116DE05F3FaE0252beCE679327179C7c78bD8B';

let myContract = new web3.eth.Contract(contarctABI, contractAddress);
(async function () {
  let newValue = 333;
  await myContract.methods
    .set(newValue)
    .send({
      from: sendAddress,
      gas: 1000000,
      gasPrice: 10000000000,
    })
    .on('transactionHash', hash => console.log('TX Hash : ', hash))
    .on('receipt', rct => console.log('Receipt: ', rct))
    .on('error', err => console.log('Error!', err));

  let res = await myContract.methods.get().call();
  console.log('\n\nReturend value: ', Number(res));
})();
