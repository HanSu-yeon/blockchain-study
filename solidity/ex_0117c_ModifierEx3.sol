// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
/*
함수 모디파이어를 사용하여 특정 조건을 만족할 때만 함수를 실행하도록 제한하는 방법을 보여줌
모디파이어는 함수의 실행 전, 후에 특정 로직을 삽입하는 역할을 하며, 재사용 가능한 코드 블록을 작성할 때 유용함
다음과 같은 용도로 사용할 수 있음
- 액세스 제한
- 입력 유효성 검사
- 재진입 해킹 방지(Guard against reentrancy hack)
*/

contract FunctionModifier{
    address public owner;
    uint256 public x = 10;
    bool public locked;

    constructor(){
        owner = msg.sender;
    }

    //함수 호출자가 계약의 소유자인지 확인
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }
    //함수의 매개변수로 전달된 주소가 유효한 주소인지 확인
    modifier validAddress(address _addr){
        require(_addr != address(0), "Not valid address");
        _;
    }

    //계약 소유자를 변경하는 함수
    //모디파이어를 통해 1. 호출자가 현재 소유자인지 확인 후 2. 입력된 주소가 유효한지 확인
    function changeOwner(address _newOwner) 
        public
        onlyOwner 
        validAddress(_newOwner)
    {   
        //조건 모두 만족하면 업데이트
        owner = _newOwner;
    }

    //함수가 재진입되는 것을 방지
    modifier noReentrancy(){
        require(!locked, "No reentrancy");
        //함수가 실행 중일 때는 locked 변수를 true로 설정하여 함수가 다시 호출되는 것을 막는다
        locked = true;
        _;
        //함수 실행이 끝나면 locked를 다시 false로 설정함
        locked = false;
    }

    //재귀 호출은 함수가 내부적으로 자기 자신을 다시 호출하는 상황임
    //이 경우, 모든 함수 호출이 "한 트랜잭션 내에서 처리"된다
    function decrement(uint256 i) public noReentrancy{
        x -= i;

        if (i > 1){
            decrement(i - 1);
        }

    }
}