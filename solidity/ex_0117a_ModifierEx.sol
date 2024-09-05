// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract ModifierEx1{

    //성인인 경우에만 호출 가능
    modifier isAdult (uint _age){
        require(_age >= 20, "Not an adult!");
        _; //함수 실행
    }

    function canDrink (uint _age) isAdult(_age)public pure  returns (bool) {
        return true;
    }

    //사용자 정의 modifier를 사용해서 함수의 wrapper 효과 내기
    uint private x = 0;
    modifier wrapper {
        x = 10;
        _;
    }

    function testWrapper() public wrapper returns (uint) {
        x += 10;
        return x;
    }
}