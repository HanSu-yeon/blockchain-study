// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//payable(지불가능한것)로 선언된 함수 및 주소(address)는 계약에 이더를 받을 수 있다
//이 계약은 ether를 수신하고 송금할 수 있는 기능을 제공함
contract Payable {

    //payable로 선언된 주소로 변수 선언
    //-> 이 주소는 이더를 받을 수 있는 주소로, 이 계약에서는 주로 이더를 송금하거나 받을 때 사용됨 
    address payable public owner;

    //payable로 선언된 생성자: 이더 수신할 수 있으며, 계약이 배포될 때 함께 이더를 전송할 수 있음
    constructor() payable {
        //owner 변수는 이 계약을 배포한 주소(msg.sender)로 설정됨
        owner = payable(msg.sender);
    }

    //payable로 선언되어 있어 이더를 보낼 수 있음
    //이 함수를 호출할 때 이더를 함께 전송할 수 있으며, 계약의 잔액은 자동으로 증가함
    function deposit() public payable{}

    //payable로 선언되지 았아서 이 함수를 호출할 때 이더를 전송하면 트랜잭션이 실패함
    //이 함수는 이더를 전송받지 않고 다른 로직을 실행하는 경우에 사용될 수 있음
    function notPayable() public{}

    //계약에 저장된 모든 이더를 계약의 owner 주소로 전송함
    function withdraw() public {
        //현재 계약에 저장된 이더의 양 가져옴
        uint256 amount = address(this).balance;
        //계약에 저장된 모든 이더를 owner에게 전송함
        //success는 이더 전송 성공 여부 나타냄
        (bool success,) = owner.call{value: amount}("");
        //전송 실패시, 트랜잭션 되돌리고 오류 메시지 반환
        require(success, "Failed to send Ether");
    }

    //_to라는 지정된 주소로 _amount 만큼의 이더를 전송함
    //_to는 payable로 선언된 주소여야 함
    function transfer(address payable _to, uint256 _amount) public {
        //이더를 전송할 때도 call을 사용
        (bool success,) = _to.call{value: _amount}("");
        //실패시 트랜잭션 되돌림
        require(success, "Failed to send Ether");
    }
}