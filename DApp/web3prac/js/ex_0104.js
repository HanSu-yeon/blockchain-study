const { Web3 } = require('web3');
const url = 'http://127.0.0.1:8545';

const web3 = new Web3(url);

let contractABI = [
  {
    inputs: [
      {
        internalType: 'uint256',
        name: '_id',
        type: 'uint256',
      },
      {
        internalType: 'string',
        name: '_message',
        type: 'string',
      },
    ],
    name: 'fireEvent1',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [
      {
        internalType: 'uint256',
        name: '_id',
        type: 'uint256',
      },
      {
        internalType: 'string',
        name: '_message',
        type: 'string',
      },
    ],
    name: 'fireEvent2',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: 'uint256',
        name: 'id',
        type: 'uint256',
      },
      {
        indexed: false,
        internalType: 'string',
        name: 'message',
        type: 'string',
      },
    ],
    name: 'myEvent1',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: 'uint256',
        name: 'id',
        type: 'uint256',
      },
      {
        indexed: false,
        internalType: 'string',
        name: 'message',
        type: 'string',
      },
    ],
    name: 'myEvent2',
    type: 'event',
  },
];

let contractAddress = '0x22667929b6a32b27B571cf6CdCe2C91Be5C83436';

let senderAddress = '0xF8116DE05F3FaE0252beCE679327179C7c78bD8B';

let myContract = new web3.eth.Contract(contractABI, contractAddress);

async function fetchEvents() {
  console.log('모든 myEvent1 이벤트 출력');
  let events1 = await myContract.getPastEvents('myEvent1', {
    fromBlock: 0,
    toBlock: 'latest',
  });
  //console.log(events);

  events1.forEach(x => {
    console.log(`Block Num: ${x.blockNumber}, BlockHash: ${x.blockHash}, ID: ${Number(x.returnValues.id)}, MESSAGE: ${x.returnValues.message}`);
  });

  console.log('\n모든 myEvent2 이벤트 출력');
  let events2 = await myContract.getPastEvents('myEvent2', {
    fromBlock: 0,
    toBlock: 'latest',
  });

  events2.forEach(x => {
    console.log(`Block Num: ${x.blockNumber}, BlockHash: ${x.blockHash}, ID: ${Number(x.returnValues.id)}, MESSAGE: ${x.returnValues.message}`);
  });

  console.log('\n이벤트 myEvent1 중 일부만 출력');
  let events3 = await myContract.getPastEvents('myEvent1', {
    filter: { id: [0, 1] },
    fromBlock: 0,
    toBlock: 'latest',
  });

  events3.forEach(x => {
    console.log(`Block Num: ${x.blockNumber}, BlockHash: ${x.blockHash}, ID: ${Number(x.returnValues.id)}, MESSAGE: ${x.returnValues.message}`);
  });
}

fetchEvents().catch(console.error);
