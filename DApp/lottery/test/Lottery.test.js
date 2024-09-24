const assert = require('assert');
const ganache = require('ganache');
const { Web3 } = require('web3');
const web3 = new Web3(ganache.provider()); //ganache 프로바이더를 Web3에 연결
const { abi, evm } = require('../compile'); //컴파일된 스마트 계약의 ABI와 bytecode를 가져옴

let accounts;
let lottery;

//테스트 실행 전 매번 호출되는 beforeEach 블록
beforeEach(async () => {
  accounts = await web3.eth.getAccounts(); //ganache가 제공하는 계정 가져오기

  //Lottery 컨트랙트 인스턴스를 생성하고 첫 번째 계정 사용해 배포 트랜잭션 보냄
  lottery = await new web3.eth.Contract(abi)
    .deploy({
      data: evm.bytecode.object,
    })
    .send({ from: accounts[0], gas: '1000000' });
});

//describe 블록으로 테스트 정의
describe('Lottery Contract', () => {
  //스마트컨트랙트가 정상적으로 배포되었는지 확인하는 테스트
  it('deploys a contract', () => {
    assert.ok(lottery.options.address); //컨트랙트 주소가 있는지 확인
  });

  // 한 명의 계정이 lottery에 참여할 수 있는지 테스트
  it('allows one account to enter', async () => {
    await lottery.methods.enter().send({
      from: accounts[0],
      value: web3.utils.toWei('0.02', 'ether'), //0.02 이더 송금
    });

    //참여자 목록 확인
    const players = await lottery.methods.getPlayers().call({
      from: accounts[0],
    });
    //참여자 목록이 올바른지 확인
    assert.equal(accounts[0], players[0]);
    assert.equal(1, players.length);
  });

  //여러 계정이 lottery에 참여할 수 있는지 확인하는 테스트
  it('allows multiple accounts to enter', async () => {
    await lottery.methods.enter().send({
      from: accounts[0],
      value: web3.utils.toWei('0.02', 'ether'),
    });

    await lottery.methods.enter().send({
      from: accounts[1],
      value: web3.utils.toWei('0.02', 'ether'),
    });

    await lottery.methods.enter().send({
      from: accounts[2],
      value: web3.utils.toWei('0.02', 'ether'),
    });

    const players = await lottery.methods.getPlayers().call({
      from: accounts[0],
    });

    assert.equal(accounts[0], players[0]);
    assert.equal(accounts[1], players[1]);
    assert.equal(accounts[2], players[2]);
    assert.equal(3, players.length);
  });

  //최소 이더 요구 사항을 테스트
  it('requires a minimum amount of ether to enter', async () => {
    try {
      await lottery.methods.enter().send({
        from: accounts[0],
        value: 0, //최소 금액보다 적은 0이더로 참여 시도
      });
      assert(false); //에러가 발생해야 하므로, 이 줄이 실행되면 실패로 간주
    } catch (err) {
      assert(err); //에러가 발생했는지 확인
    }
  });

  //매니저만 pickWinner를 호출할 수 있는지 확인하는 테스트
  it('only manager can call pickWinner', async () => {
    try {
      await lottery.methods.pickWinner().send({
        from: accounts[1],
      });
      assert(false);
    } catch (err) {
      assert(err);
    }
  });

  //승자가 돈을 받고 플레이어 배열이 초기화되는지 확인하는 테스트
  it('sends money to the winner and resets the players array', async () => {
    await lottery.methods.enter().send({
      from: accounts[0],
      value: web3.utils.toWei('2', 'ether'),
    });

    const initialBalance = await web3.eth.getBalance(accounts[0]); //초기 잔액 저장
    await lottery.methods.pickWinner().send({ from: accounts[0] }); //승자 선택
    const finalBalance = await web3.eth.getBalance(accounts[0]); //최종 잔액 저장
    const difference = finalBalance - initialBalance; //잔액 차이 계산

    assert(difference > web3.utils.toWei('1.8', 'ether'));
  });
});
