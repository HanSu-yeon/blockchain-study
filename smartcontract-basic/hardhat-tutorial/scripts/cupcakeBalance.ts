import { ethers } from 'hardhat';
import { VendingMachine } from '../typechain-types';

const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
const account = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';

async function getBalance(contractAddress: string, account: string) {
  try {
    console.log('getBalance from vendingMachine contract');
    //1.입력값 검증
    if (!ethers.isAddress(contractAddress) || !ethers.isAddress(account)) {
      throw new Error('Invalid address');
    }
    //2.컨트랙트 인스턴스 가져오기
    const VendingMachine = await ethers.getContractFactory('VendingMachine');
    const vendingMachine = (await VendingMachine.attach(contractAddress)) as VendingMachine;
    //3.재고 조회
    const balance = await vendingMachine.cupcakeBalances(account);
    console.log('account cupcake balance', balance.toString());
  } catch (error) {
    console.error('Error during getBalance', error);
    throw error;
  }
}

getBalance(contractAddress, account).catch(error => {
  console.error('script failed', error);
  process.exitCode = 1;
});
