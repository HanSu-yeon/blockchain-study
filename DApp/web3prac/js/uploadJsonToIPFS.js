// IPFS에 NFT 메타데이터 올리기
// 순서: Pinata에 이미지 업로드 -> 업롤드된 이미지의 cid 사용해서 메타데이터 파일 생성 -> Pinata에 업로드

const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const { myAPIKey, mySecretAPIKey } = require('./myKeys.json');

const fileName = 'monkey_02.png';
const metadataName = 'monkey_02.json';
//파일(이미지, 동영상, PDF 등)을 IPFS에 업로드하는 API
const url1 = 'https://api.pinata.cloud/pinning/pinFileToIPFS';
//JSON 데이터를 IPFS에 업로드하는 API
const url2 = 'https://api.pinata.cloud/pinning/pinJSONToIPFS';

let data = new FormData();

data.append('file', fs.createReadStream(`../imgs/${fileName}`));

(async function () {
  let imgCid = '';
  let metadataCid = '';
  let res;

  try {
    res = await axios.post(url1, data, {
      headers: {
        'Content-Type': `multipart/form-data; boundary= ${data._boundary}`,
        pinata_api_key: myAPIKey,
        pinata_secret_api_key: mySecretAPIKey,
      },
    });

    imgCid = `ipfs://${res['data']['IpfsHash']}`;

    const metadata = JSON.stringify({
      pinataContent: {
        name: fileName,
        description: 'IPFS 테스트를 위한 원숭이 테스트 이미지입니다.',
        image: imgCid,
      },
      pinataMetadata: {
        name: metadataName,
      },
    });

    console.log(metadata);

    try {
      res = await axios.post(url2, metadata, {
        headers: {
          'Content-Type': 'application/json',
          pinata_api_key: myAPIKey,
          pinata_secret_api_key: mySecretAPIKey,
        },
      });
      metadataCid = `ipfs://${res['data']['IpfsHash']}`;

      console.log('Metadata CID : ', metadataCid);
    } catch (err) {
      console.log('메타데이터 업로드 중 오류발생!');
    }
  } catch (err) {
    console.log('이미지 업로드 중 오류발생!');
  }
})();
