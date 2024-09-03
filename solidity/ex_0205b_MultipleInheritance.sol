// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//다중 상속 예제
contract AccountA {
    uint private balance = 100;
    function getBalance() public view virtual returns (uint){
        return balance;
    }
}

contract AccountB{
    string private name = "John";
    function getName() public view virtual returns (string memory){
        return name;
    }
}

contract DerivedAccount is AccountA, AccountB{
    //오버라이딩은 옵션

    //getBalance 오버라이드
    function getBalance() public view override returns(uint){
        uint balance = AccountA.getBalance();
        balance /= 100;
        return balance;
    }

    //getName은 오버라이드 하지 않음 -> 부모 계약인 AccountB의 원래 구현을 그대로 사용함
}