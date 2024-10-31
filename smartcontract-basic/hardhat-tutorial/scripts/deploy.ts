import { ethers } from 'hardhat';

async function main() {
  console.log('deploying vendingMachine contract');
  //컨트랙트를 생성하기 위한 팩토리
  const VendingMachine = await ethers.getContractFactory('VendingMachine');
  //실제 배포된 컨트랙트 인스턴스
  const vendingMachine = await VendingMachine.deploy();

  //deployed() -> waitForDeployment()로 대체
  await vendingMachine.waitForDeployment();

  //contractInstance.address -> await contractInstance.getAddress()로 대체
  console.log(`vendingMachine contract is deployed to ${await vendingMachine.getAddress()}`);
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
