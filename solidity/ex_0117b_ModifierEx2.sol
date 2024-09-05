// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//modifier는 함수 호출 전에 조건을 검증하는 역할을 함
contract ModifierEx2 {
    //계약을 배포한 사람만 특정 함수에 접근할 수 있도록 제한
    address private allowed;

    modifier allowedOnly{
        if(msg.sender == allowed){
            _; //조건 만족하면 함수 실
        }else{
            revert();
        }
    }
    constructor(){
        allowed = msg.sender;
    }

    function testAllowed() public view allowedOnly returns(string memory){
        return "Hello";
    }

    uint private endTime = block.timestamp + 1 minutes;
    //계약 배포된 후 1분 이내에만 함수가 실행되도록 제한
    modifier timeOut{
        if(block.timestamp < endTime){
            _;
        }else{
            revert();
        }
    }

    //timeOut modifier를 통해 호출 시점이 계약이 배포된 후 1분 이내일 경우에만 실행됨
    function testTimeout() public view timeOut returns(uint){
        //시간이 남았을 경우 남은 시간을 초 단위로 반환
        //1분 지나면 실행되지 않고 에러 발생
        uint untilTimeout = endTime - block.timestamp;
        return untilTimeout;
    }



}