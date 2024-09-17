//Remix에서 직접 버튼을 눌러 함수를 호출하던 것을 코드로 직접 할 수 있음
//promise 사용
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

//배포된 스마트 계약의 ABI와 주소를 사용해 스마트계약 객체 생성
//이 객체를 통해 스마트계약의 함수들을 호출할 수 있음
let myContract = new web3.eth.Contract(contarctABI, contractAddress);

let newValue = 123456;
//set: 상태 변경 함수 호출
let promise = myContract.methods.set(newValue).send({
  from: sendAddress,
  gas: 1000000,
  gasPrice: 10000000000,
});

promise.then(() => {
  //get은 상태를 조회하는 함수 -> 네트워크의 상태 변경하지 x -> call()로 호출
  myContract.methods
    .get()
    .call()
    .then(x => {
      console.log(Number(x));
    });
});
