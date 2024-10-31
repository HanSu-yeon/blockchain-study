import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('VendingMachine', function () {
  async function VendingMachineFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const VendingMachine = await ethers.getContractFactory('VendingMachine');
    const vendingMachine = await VendingMachine.deploy();

    return { vendingMachine, owner, otherAccount };
  }

  describe('VendingMachine', function () {
    it('생성자에서 100개의 컵케이크를 만들어야 함', async function () {
      const { vendingMachine } = await loadFixture(VendingMachineFixture);
      //stockBalance(): getter함수
      expect(await vendingMachine.stockBalance()).to.equal(100);
    });

    it('구매 후 올바르게 컵케이크 보내야 함', async function () {
      const { vendingMachine, otherAccount } = await loadFixture(VendingMachineFixture);

      console.log('VendingMachine cupcake balance: ', await vendingMachine.stockBalance());

      const initalBalance = await vendingMachine.cupcakeBalances(otherAccount.address);
      console.log('Inital buyer balance: ', initalBalance);
      let amount = 10;
      await expect(vendingMachine.connect(otherAccount).purchase(amount, { value: (amount * 10 ** 18).toString() }))
        .to.emit(vendingMachine, 'Purchase')
        .withArgs(otherAccount.address, amount);

      const finalBalance = await vendingMachine.cupcakeBalances(otherAccount.address);
      console.log('final buyer balance: ', finalBalance);
      console.log('Final  stockBalance: ', await vendingMachine.stockBalance());
      console.log('VendingMachine cupcake balance: ', await vendingMachine.stockBalance());
      expect(finalBalance).to.equal(initalBalance + BigInt(amount));
    });
  });

  it('컵케이크가 올바르게 리필되어야 함', async function () {
    const { vendingMachine, owner } = await loadFixture(VendingMachineFixture);

    console.log('Inital cupcake balance: ', await vendingMachine.stockBalance());
    const amount = 10;
    await vendingMachine.connect(owner).refill(amount);
    console.log('Final cupcake balance: ', await vendingMachine.stockBalance());

    expect(await vendingMachine.stockBalance()).to.equal(110);
  });
});
