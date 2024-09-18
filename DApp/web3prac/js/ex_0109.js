//NFT 민팅

let App = {
  img: {
    imgUploadUrl: 'https://api.pinata.cloud/pinning/pinFileToIPFS',
    jsonUploadUrl: 'https://api.pinata.cloud/pinning/pinJSONToIPFS',
    myAPIKey: '',
    mySecretAPIKey: '',
    imgFile: null,
    imgFileName: '',
    imgCID: '',
    metadataCID: '',
    metadata: {},
  },

  web3: null,

  contractABI: [
    {
      inputs: [
        {
          internalType: 'string',
          name: '_name',
          type: 'string',
        },
        {
          internalType: 'string',
          name: '_symbol',
          type: 'string',
        },
      ],
      stateMutability: 'nonpayable',
      type: 'constructor',
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: 'address',
          name: 'owner',
          type: 'address',
        },
        {
          indexed: true,
          internalType: 'address',
          name: 'approved',
          type: 'address',
        },
        {
          indexed: true,
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'Approval',
      type: 'event',
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: 'address',
          name: 'owner',
          type: 'address',
        },
        {
          indexed: true,
          internalType: 'address',
          name: 'operator',
          type: 'address',
        },
        {
          indexed: false,
          internalType: 'bool',
          name: 'approved',
          type: 'bool',
        },
      ],
      name: 'ApprovalForAll',
      type: 'event',
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: 'address',
          name: 'from',
          type: 'address',
        },
        {
          indexed: true,
          internalType: 'address',
          name: 'to',
          type: 'address',
        },
        {
          indexed: true,
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'Transfer',
      type: 'event',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'to',
          type: 'address',
        },
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'approve',
      outputs: [],
      stateMutability: 'nonpayable',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'owner',
          type: 'address',
        },
      ],
      name: 'balanceOf',
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
    {
      inputs: [
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'getApproved',
      outputs: [
        {
          internalType: 'address',
          name: '',
          type: 'address',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'owner',
          type: 'address',
        },
        {
          internalType: 'address',
          name: 'operator',
          type: 'address',
        },
      ],
      name: 'isApprovedForAll',
      outputs: [
        {
          internalType: 'bool',
          name: '',
          type: 'bool',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: '_awardee',
          type: 'address',
        },
        {
          internalType: 'string',
          name: '_tokenURI',
          type: 'string',
        },
      ],
      name: 'mintNFT',
      outputs: [
        {
          internalType: 'uint256',
          name: '',
          type: 'uint256',
        },
      ],
      stateMutability: 'nonpayable',
      type: 'function',
    },
    {
      inputs: [],
      name: 'name',
      outputs: [
        {
          internalType: 'string',
          name: '',
          type: 'string',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'ownerOf',
      outputs: [
        {
          internalType: 'address',
          name: '',
          type: 'address',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'from',
          type: 'address',
        },
        {
          internalType: 'address',
          name: 'to',
          type: 'address',
        },
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'safeTransferFrom',
      outputs: [],
      stateMutability: 'nonpayable',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'from',
          type: 'address',
        },
        {
          internalType: 'address',
          name: 'to',
          type: 'address',
        },
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
        {
          internalType: 'bytes',
          name: '_data',
          type: 'bytes',
        },
      ],
      name: 'safeTransferFrom',
      outputs: [],
      stateMutability: 'nonpayable',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'operator',
          type: 'address',
        },
        {
          internalType: 'bool',
          name: 'approved',
          type: 'bool',
        },
      ],
      name: 'setApprovalForAll',
      outputs: [],
      stateMutability: 'nonpayable',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'bytes4',
          name: 'interfaceId',
          type: 'bytes4',
        },
      ],
      name: 'supportsInterface',
      outputs: [
        {
          internalType: 'bool',
          name: '',
          type: 'bool',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [],
      name: 'symbol',
      outputs: [
        {
          internalType: 'string',
          name: '',
          type: 'string',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'tokenURI',
      outputs: [
        {
          internalType: 'string',
          name: '',
          type: 'string',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: 'from',
          type: 'address',
        },
        {
          internalType: 'address',
          name: 'to',
          type: 'address',
        },
        {
          internalType: 'uint256',
          name: 'tokenId',
          type: 'uint256',
        },
      ],
      name: 'transferFrom',
      outputs: [],
      stateMutability: 'nonpayable',
      type: 'function',
    },
  ],

  contractAddress: '0xcEa1711f0F5D4bEF50BD2261Cf4A5AC45c231d92',
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
      console.log('오류! web3를 불러 올수 없음');
    }
  },

  initContract: function () {
    this.myContract = new this.web3.eth.Contract(this.contractABI, this.contractAddress);
  },

  callMintNFT: async function () {
    let senderAddress = (await this.web3.eth.getAccounts())[0];

    await this.myContract.methods.mintNFT(senderAddress, this.img.metadataCID).send({ from: senderAddress });
    console.log('민팅 성공!');
    location.reload();
  },
};

async function uploadIPFS() {
  try {
    $('#result').text('처리중...');
    let data = new FormData();
    data.append('file', App.img.imgFile);
    let res = await axios.post(App.img.imgUploadUrl, data, {
      headers: {
        'Content-Type': `multipart/form-data; boundary=${data._boundary}`,
        pinata_api_key: App.img.myAPIKey,
        pinata_secret_api_key: App.img.mySecretAPIKey,
      },
    });
    App.img.imgCID = `ipfs://${res['data']['IpfsHash']}`;

    App.img.metadata['pinataContent'] = {};
    App.img.metadata['pinataContent']['description'] = $('description').val();
    App.img.metadata['pinataContent']['image'] = App.img.imgCID;
    App.img.metadata['pinataContent']['name'] = App.img.imgFileName;
    App.img.metadata['pinataMetadata'] = {};
    App.img.metadata['pinataMetadata']['name'] = App.img.imgFileName.split('.')[0] + '.json';

    try {
      res = await axios.post(App.img.jsonUploadUrl, App.img.metadata, {
        headers: {
          'Content-Type': 'application/json',
          pinata_api_key: App.img.myAPIKey,
          pinata_secret_api_key: App.img.mySecretAPIKey,
        },
      });
      App.img.metadataCID = `ipfs://${res['data']['IpfsHash']}`;
      $('#result').text('Metadata CID: ' + App.img.metadataCID);
      $('#mintButton').show();
    } catch (err) {
      console.log('메타데이터 올리는 도중 오류발생!');
      $('#result').text('');
    }
  } catch (err) {
    alert('이미 올리는 도중 오류발생!');
    $('#result').text('');
  }
}

$(function () {
  $('#result').text('');
  $('#mintButton').hide();
  $('#upload').change(e => {
    App.img.imgFile = e.target.files[0];
    App.img.imgFileName = e.target.files[0].name;
  });
  $('#uploadButton').click(() => {
    uploadIPFS();
  });
  $.getJSON('../js/myKeys.json', data => {
    App.img.myAPIKey = data['myAPIKey'];
    App.img.mySecretAPIKey = data['mySecretAPIKey'];
  });

  App.initWeb3();
  if (App.web3) {
    App.initContract();
    $('#mintButton').on('click', function () {
      App.callMintNFT();
    });

    window.ethereum.on('accountsChanged', function () {
      location.reload();
    });
  }
});
