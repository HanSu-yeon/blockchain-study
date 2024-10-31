import { ethers } from 'hardhat';
import { VendingMachine } from '../typechain-types';
const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

async function getPurchaseEvents() {
  try {
    //1.컨트랙트 연결
    const VendingMachine = await ethers.getContractFactory('VendingMachine');
    const vendingMachine = (await VendingMachine.attach(contractAddress)) as VendingMachine;

    //2. 이벤트 필터 설정
    const purchaseEventSignature = ethers.id('Purchase(address,uint256)'); //이벤트 시그니처 해시
    console.log(purchaseEventSignature);
    const filter = {
      address: contractAddress,
      fromBlock: 0, //시작 블록
      toBlock: 'latest', //끝블록
      topics: [purchaseEventSignature], //필터링할 이벤트 주제
    };
    //3.로그 가져오기
    const logs = await ethers.provider.getLogs(filter);
    if (logs.length === 0) {
      console.log('No purchase events found');
      return;
    }
    // console.log('Event logs: ', logs);

    //4.로그 해석을 위해 ABI 및 인터페이스 설정
    const { abi } = require('../artifacts/contracts/VendingMachine.sol/VendingMachine.json');
    const iface = new ethers.Interface(abi);
    // console.log('iface', iface);

    //5.로그 분석
    for (const log of logs) {
      const receipt = await ethers.provider.getTransactionReceipt(log.transactionHash);
      if (!receipt) continue;
      receipt.logs.forEach(eventLog => {
        try {
          const parsedLog = iface.parseLog(eventLog);
          if (!parsedLog) return;

          console.log(`Purchase Event:`, {
            purchaser: parsedLog.args[0],
            amount: parsedLog.args[1].toString(),
            blockNumber: receipt.blockNumber,
            transactionHash: receipt.hash,
          });
        } catch (error) {
          console.error('Error parsing log:', error);
        }
      });
    }
  } catch (error) {
    console.error('Error in getPurchaseEvents', error);
    throw error;
  }
}

getPurchaseEvents().catch(error => {
  console.error('Script failed: ', error);
  process.exitCode = 1;
});
