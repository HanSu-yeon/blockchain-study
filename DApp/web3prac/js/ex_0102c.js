App = {
  web3: null,

  privateKeySender: 'f2f289e3e6e86a1148f419f20e91f2d4ce696323b6079f6d7fac729709f0d5c2',

  addr_receiver: '0xac7bd2E9c0f2CabEdD7Cb991dD60C6c3EFDA615a',

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
      console.log('오류! web3를 불러올 수 없음');
    }
  },

  // Ether 보내주는 함수.
  sendEther: async function () {
    let sendValue = Number($('#userInput').val());

    $('#userInput').val('');

    let txObject = {
      to: this.addr_receiver,
      gasPrice: 10000000000,
      gas: 3000000,
      value: sendValue,
      data: '',
    };

    try {
      let signedTX = await this.web3.eth.accounts.signTransaction(txObject, this.privateKeySender);
      let sendTX = await this.web3.eth.sendSignedTransaction(signedTX.rawTransaction);
      $('#show').text('성공');
    } catch (err) {
      $('#show').text(err.message);
    }
  },
};

$(function () {
  App.initWeb3();
  if (App.web3) {
    $('#sendButton').on('click', function () {
      App.sendEther();
    });

    window.ethereum.on('accountsChanged', function () {
      location.reload();
    });
  }
});
