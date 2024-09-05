// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/*
두 개의 스마트계약 정의
- ReceiveEther: 이더 수신
- SendEther: 이더 송금
*/

/*
    fallback() 또는 receive() 중 어떤 함수가 호출되나요?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
    receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */
contract ReceiveEther {

    //msg.data가 비어 있을 때 이 함수가 호출됨
    //external: 외부에서만 호출될 수 O
    //payable: 이더를 받을 수 O
    receive() external payable{}

    //msg.data가 비어 있지 않을 때 호출됨
    fallback() external payable{}

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }
}

contract SendEther{
    //현재 권장 x. 이더리움 가스 한도 문제로 인해 실패할 수 있는 가능성이 있음
    function sendViaTransfer(address payable _to) public payable{
        _to.transfer(msg.value);
    }
    //현재 권장 x. 실패 시 tx이 자동으로 되돌려지지 않기 때문에 추가적인 에러 처리가 필요
    function sendViaSend(address payable _to) public payable{
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }
    //현재 권장되는 사용 방
    function sendViaCall(address payable _to) public payable{
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}