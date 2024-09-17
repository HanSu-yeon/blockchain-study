App = {
  web3: null,

  contarctABI: [
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
  ],

  contractAddress: '0x1852C00a5A728F6e1bB460b15906cB7f928E75da',

  myContract: null,

  initWeb3: function () {
    if (typeof web3 !== 'undefined') {
      console.log('Web3 불러왔음');
      window.ethereum.request({ method: 'eth_requestAccounts' });

      if (window.ethereum.isMetaMask) {
        this.web3 = new Web3(window.ethereum);
        console.log('메타마스크 준비됨');
      } else {
        console.log('메타마스크 사용 불가');
      }
    } else {
      console.log('오류! Web3를 불러 올 수 없음');
    }
  },

  initContract: function () {
    this.myContract = new this.web3.eth.Contract(this.contarctABI, this.contractAddress);
  },

  callSet: async function () {
    let sendAddress = (await this.web3.eth.getAccounts())[0];

    let newValue = Number($('#userInput').val());
    $('#userInput').val('');

    await this.myContract.methods.set(newValue).send({ from: sendAddress });
  },

  callGet: async function () {
    let res = await this.myContract.methods.get().call();
    $('#result').text(res);
  },
};

$(function () {
  App.initWeb3();
  if (App.web3) {
    App.initContract();

    $('#setBtn').on('click', function () {
      App.callSet();
    });

    $('#getBtn').on('click', function () {
      App.callGet();
    });
  }
});
