// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//간단한 입출금 기능을 제공하는 스마트컨트랙트
//overflow와 underflow를 방지하기 위한 오류 처리 로직 포함
//require: 주로 외부 입력 검증에 사용, 조건 충족되지 않으면 트랜잭션 중단됨
//assert: 코드 내에서 절대적으로 참이어야 하는 조건을 확인하는 데 사용, 실패시 트랜잭션 중단됨
contract Account{
    uint256 public balance; //현재 계좌의 잔액
    uint256 public constant MAX_UINT = 2 ** 256 - 1; //uint256 자료형이 가질 수 있는 최대 값을 상수로 정의, overflow 방지용으로 사용

    //예금 추가
    function deposit(uint256 _amount) public {
        uint256 oldBalance = balance;
        uint256 newBalance = balance + _amount; //기존 잔액에 _amount를 더하여 새로운 잔액 계산
    
        //오버플로우가 발생하지 않도록 require로 확인
        //balance + _amount >= balance 인 경우 overflow 발생하지 않는다
        //상태 변수 변경하기 전에 실행됨
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;
        //예금 후에도 balance(새로운 잔액)가 이전 잔액보다 크거나 같은지 assert를 통해 확인
        assert(balance >= oldBalance); //예금 후 잔액이 항상 이전 잔액보다 크거나 같음을 보장
    }

    //출금
    function withdraw(uint256 _amount) public {
        uint256 oldBalance = balance;

        //출금하려는 금액이 잔액보다 크지 않은지 확인하기 위해 require 사용
        // 잔액이 >= _amount(금액)인 경우 underflow가 발생하지 않는다
        require(balance >= _amount, "Underflow");
        
        //출금 금액이 잔액보다 크다면 revert를 사용해 트랜잭션 중단
        if(balance < _amount){
            revert("Underflow");
        }

        balance -= _amount;
        //출금 후 잔액(balance)이 이전 잔액보다 작거나 같은지 assert를 통해 확인
        assert(balance <= oldBalance); //출금 후 잔액이 항상 이전 잔액보다 작거나 같음을 보장
    }

}