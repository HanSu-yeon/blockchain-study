// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//다중 상속 예제
//하나의 계약이 둘 이상의 부모 계약을 상속받는 경우를 말함
contract AccountA {
    uint private balance = 100;
    function getBalance() public view virtual returns (uint){
        return balance;
    }
}

contract AccountB{
    uint private balance = 200;
    //virtual로 선언되어 있어, 하위 계약에서 오버라이딩할 수 있음
    function getBalance() public view virtual returns (uint){
        return balance;
    }
}

contract DerivedAccount is AccountA, AccountB{
    
    //각각의 getBalance() 함수를 호출하여 두 잔액의 합을 반환
    //부모 계약인 AccountA와 AccountB에서 상속된 동일한 이름의 함수를 오버라이딩함
    // function getBalance() public view override(AccountA, AccountB) returns(uint){
    //     uint sum = AccountA.getBalance() + AccountB.getBalance();
    //     return sum;
    // }

    //다중 사속에서 상속 순서가 중요
    //상속 순서: AccountA -> AccountB 
    //즉, AccountB가 나중임 -> AccountB의 getBalance()가 호출됨
    function getBalance() public view override(AccountA, AccountB) returns(uint){
        return super.getBalance();
    }
}