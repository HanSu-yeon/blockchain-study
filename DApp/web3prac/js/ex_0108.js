// 웹사이트를 통해서 입력받은 이미지와 메타데이터를 pinata api를 통해 ipfs에 업로드 하는 코드

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
    App.img.metadata['pinataContent']['description'] = $('#description').val();
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
    } catch (err) {
      console.log('메타데이터 올리는 도중 오류발생!');
      $('#result').text('');
    }
  } catch (err) {
    alert('이미지 올리는 도중 오류발생!');
    $('#result').text('');
  }
}

$('#result').text('');
$('#upload').change(e => {
  App.img.imgFile = e.target.files[0];
  App.img.imgFileName = e.target.files[0].name;
});

$('#btn_upload').click(() => {
  uploadIPFS();
});
$.getJSON('../js/myKeys.json', data => {
  App.img.myAPIKey = data['myAPIKey'];
  App.img.mySecretAPIKey = data['mySecretAPIKey'];
});
