// Pinata API에 접속하여 테스트
require('dotenv').config();

const options = { method: 'GET', headers: { Authorization: `Bearer ${process.env.JWT_TOKEN}` } };

//Pinata API의 testAuthentication 엔드포인트 호출
fetch('https://api.pinata.cloud/data/testAuthentication', options)
  .then(response => response.json())
  .then(response => console.log(response))
  .catch(err => console.error(err));
