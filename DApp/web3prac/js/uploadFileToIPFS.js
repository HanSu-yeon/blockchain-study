//IPFS에 이미지 올리기

const axios = require('axios');
const fs = require('fs');

const FormData = require('form-data');

const { myAPIKey, mySecretAPIKey } = require('./myKeys.json');

const url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

let data = new FormData();

data.append('file', fs.createReadStream('../imgs/monkey_01.png'));

(async function () {
  try {
    let res = await axios.post(url, data, {
      headers: {
        'Content-Type': `multipart/form-data; boundary= ${data._boundary}`,
        pinata_api_key: myAPIKey,
        pinata_secret_api_key: mySecretAPIKey,
      },
    });
    console.log(`ipfs://${res['data']['IpfsHash']}`);
  } catch (err) {
    console.log('오류발생!');
  }
})();
