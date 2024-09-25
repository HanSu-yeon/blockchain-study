// solidity 컴파일러(solc)를 이용해 컨트랙트를 컴파일함
const path = require('path');
const fs = require('fs');
const solc = require('solc');

// 현재 디렉토리(__dirname)에서 contracts폴더 안에 있는 Lottery.sol 파일의 절대 경로를 생성함
const lotteryPath = path.resolve(__dirname, 'contracts', 'Lottery.sol');
// console.log(lotteryPath);
//이 경로에서 Lottery.sol 파일을 읽어와 그 내용을 source 변수에 담는다. 파일 인코딩은 utf8로 설정
const source = fs.readFileSync(lotteryPath, 'utf8');
// console.log(source);

/** 컴파일러 입력 설정
 * sources: 컴파일할 파일 목록 명시하고, 내용을 source 변수에서 가져옴
 * settings.outputSelection: 컴파일러가 반환할 정보를 설정함. '*'로 지정되어 있어 모든 출력(ABI, 바이트코드 등)을 가져오도록 설정
 */
const input = {
  language: 'Solidity',
  sources: {
    'Lottery.sol': {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*'],
      },
    },
  },
};

/**
 * 컴파일 및 결과 내보내기
 * solc.compile: input객체를 JSON 형식으로 변환해 solc 컴파일러에 전달함
 * JSON.parse: 컴파일된 결과를 JSON으로 다시 변환함
 * contracts['Lottery.sol'].Lottery: Lottery.sol 파일 안의 Lottery 컨트랙트의 컴파일 결과를 가져옴
 * module.exports: 컴파일된 Lottery 컨트랙트를 모듈로 내보냄
 */
module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts['Lottery.sol'].Lottery;
