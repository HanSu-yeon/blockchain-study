// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
/*
call 함수를 사용하여 다른 스마트 계약과 상호작용하는 방법 보여줌
call은 저수준 함수로서, solidity에서 이더 전송하거나 특정 함수 호출할 때 사용할 수 있음

저수준 함수 call이 권장되지 않는 이유
- revert가 전파되지 않음 -> 호출이 실패했는지 직접 확인해야 함
  (예제에서는 success 플래그를 통해 성공 여부 확인)
- 타입 검사가 생략됨 -> 함수 서명을 잘못 입력하거나 잘못된 데이터 유형을 전달하면 문제가 발생할 수 있다
- 함수 존재 여부 확인이 생략됨 -> call은 존재하지 않는 함수 호출할 수 있다 이런 경우 fallback 함수가 호출됨
  > 방지하려면 고수준 함수 사용하는 것이 좋다(transfer, send)
*/
contract Receiver{
    event Received(address caller, uint256 amount, string message);

    //fallback함수는 계약에 존재하지 않는 함수를 호출하거나 데이터 없이 이더를 보낼 때 실행됨
    fallback() external payable{
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory _message, uint256 _x)
        public 
        payable 
        returns (uint256)
    {
        emit Received(msg.sender, msg.value, _message);
        return _x + 1;
    }
}

//Receiver 계약 호출하고, 그 호출이 성공했는지 여부와 데이터를 확인하는 기능을 포함
contract Caller {
    event Response(bool success, bytes data);

    function testCallFoo(address payable _addr) public payable {
        //_addr: 호출하려는 계약 주소(Receiver)
        //abi.encodeWithSignature: 호출하려는 함수의 서명을 인코딩하여 전달
        //*함수의 서명: 함수이름과 매개변수의 데이터 타
        (bool success, bytes memory data) = _addr.call{
            value: msg.value, //송금할 이더(ether)의 양
            gas: 5000 //호출에 사용할 가스 양
        }(abi.encodeWithSignature("foo(string, uint256)", "call foo", 123));

        emit Response(success, data);
    }
    //call로 존재하지 않는 함수 호출 -> fallback 함수가 호출됨
    function testCallDoesNotExist(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}