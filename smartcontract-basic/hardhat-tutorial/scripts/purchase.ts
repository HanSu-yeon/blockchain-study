import { ethers } from 'hardhat';
import { VendingMachine } from '../typechain-types';

const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

async function purchase(amount: number) {
  try {
    console.log('purchase from vendingMachine contract');
    const VendingMachine = await ethers.getContractFactory('VendingMachine');
    const vendingMachine = (await VendingMachine.attach(contractAddress)) as VendingMachine;
    //현재 재고 확인
    const currentStock = await vendingMachine.stockBalance();
    console.log('Current Stock:', currentStock.toString());
    const purchaseTx = await vendingMachine.purchase(amount, { value: (amount * 10 ** 18).toString() });
    console.log('Transaction sent! Hash:', purchaseTx.hash);
    //트랜잭션 완료 대기
    const receipt = await purchaseTx.wait();
    console.log('Purcahse completed! Gas used:', receipt?.gasUsed.toString());
    // console.log('purchase: ', purchase);
    //구매 후 재고 확인
    const newStock = await vendingMachine.stockBalance();
    console.log('new stock:', newStock.toString());
  } catch (error) {
    console.error('Error during purchase:', error);
    throw error;
  }
}

purchase(10).catch(error => {
  console.error('script failed', error);
  process.exitCode = 1;
});
