// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/*
EOA(개인계정)에 송금하는 방법 예시
세 가지 방법으로 이더를 송금할 수 있

- transfer (2300 gas, throws error)
- send (2300 gas, returns bool)
- call (forward all gas or set gas, returns bool)

call을 re-entrancy guard와 함께 사용되는 것이 권장되는 방법
*/
contract PayToEOA{
    //송금이 성공적으로 완료된 후 발생하는 이벤트, 송금된 금액을 기록
    event PaymentSuccessful(uint _amount);

    //send함수는 성공 여부를 불리언 값으로 반환
    function sendTo(address payable _to) public payable{
        //리턴값이 false인 경우 전송 실패를 의미하는 거지 트랜잭션의 실패가 아니다
        bool result = _to.send(msg.value); //송금 실패시 트랜잭션 자동으로 되돌리지 않음
        require(result, "Send function failed"); //false면 require를 사용하여 트랜잭션 되돌리며 에러 메시지 출력(수동 예외 처리)
        emit PaymentSuccessful(msg.value); //true(송금 성공)하면 이벤트 발생
    }

    //transfer는 송금 실패 시 "자동"으로 tx 되돌림. 따로 반환값을 처리하지 않음
    //송금에 사용할 수 있는 가스량이 제한되어 있음
    //현재 권장 x. 이더리움 가스 한도 문제로 인해 실패할 수 있는 가능성이 있음
    function transferTo(address payable _to) public payable{
        _to.transfer(msg.value);
        emit PaymentSuccessful(msg.value); //송금 성공시 이벤트 발생
    }

    //버전 0.7 이후 문법
    //call은 불리언 값으로 성공 여부 반환, 추가적으로 데이터를 반환할 수 있음
    function callTo(address payable _to) public payable {
        (bool result, ) = _to.call{value: msg.value, gas: 2000}(""); //송금에 사용할 가스량 제한(call은 직접 설정할 수 있음)
        require(result, "Call function failed."); //송금 실패시 tx 되돌림
        emit PaymentSuccessful(msg.value); //송금 성공시 이벤트 발생
    }
}