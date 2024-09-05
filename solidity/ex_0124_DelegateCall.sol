// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//delegatecall을 사용하며 A가 B의 코드를 실행하는 예시
//delegatecall은 한 계약에서 다른 계약의 함수를 호출할 때 호출하는 계약의 저장소와 컨텍스트를 유지하면서 코드를 실행할 수 있는 방법이다
//업그레이드 가능한 계약 패턴에서 사용됨
//주의할 점: 저장소의 레이아
contract B {
    uint256 public num;
    address public sender;
    uint256 public value;

    //세 가지 상태 변수를 업데이트하는 함수
    function setVars(uint256 _num) public payable{
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A{
    uint public num;
    address public sender;
    uint256 public value;

    //delegatecall을 통해 다른 계약 B의 setVars 함수를 호출
    //B의 코드를 호출하지만 A 계약의 상태 변수를 업데이트 하고 B의 상태 변수는 전혀 변경되지 않음
    function setVars(address _contract, uint256 _num) public payable{
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}