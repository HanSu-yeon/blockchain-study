// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/*
fallback은 다음과 같은 경우에 실행되는 특수 함수
- 존재하지 않는 함수가 호출되거나
- 이더가 컨트랙트로 직접 전송되었지만 receive()가 존재하지 않거나 msg.data가 비어있지 않을때

fallback은 transfer 또는 send로 호출할 때 2300 가스 한도가 있다
*/

contract Fallback {
    event Log(string func, uint256 gas);

    //fallback은 계약에 이더가 전송될 때와 msg.data가 비어있지 않을 때 호출됨
    //주로 잘못된 함수 호출이나 없는 함수에 대한 호출이 발생할 때 작동함
    fallback() external payable{
        //실행된 함수와 남은 가스를 기록
        emit Log("fallback", gasleft());
    }

    //receive는 msg.data가 비어있을 때 이더가 전송되면 호출
    receive() external payable{
        emit Log("receive", gasleft());
    }

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }
}

//이더를 전송하려는 주소가 Fallback 계약이면 receive 또는 fallback 함수가 호출됨 
contract SendToFallback {

    //매개변수에 payable 지정하는 이유: 해당 주소가 이더리움을 받을 수 있는 주소임을 명확히 하기 위함
    function transferToFallback(address payable _to) public payable{
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable{
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
