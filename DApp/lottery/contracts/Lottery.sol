// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Lottery {
    //매니저(계약을 생성한 사람)의 주소 저장하는 변수
    address public manager;
    //플레이어들을 저장하는 배열. 각 플레이어는 송금이 가능한 주소(payable)
    address payable[] public players;

    //생성자 함 수로, 계약을 생성한 사람(msg.sender)를 매니저로 설정
    constructor() {
        manager = msg.sender;
    }

    //플레이어가 lottery에 참여할 수 있게 해주는 함수
    //최소 0.01 이더 이상을 보내야 참여 가능 
    function enter() public payable {
        require(msg.value > .01 ether); //참여자가 0.01 이더 이상 송금했는지 확인
        players.push(payable(msg.sender)); //참여자를 players 배열에 추가
    }
    
    //난수 생성하는 내부(private) 함수
    //블록 난이도, 타임스탬프, 플레이어 목록을 사용해 해시 생성
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    //매니저만 호출할 수 있는 승자 선택 함수
    //무작위로 한 명의 플레이어를 선택해 잔액을 전송 
    function pickWinner() public restricted{
        uint index = random() % players.length; //난수로 인덱스 생성
        players[index].transfer(address(this).balance); //해당 플레이어에게 잔액 전송
        players = new address payable[](0);//플레이어 배열 초기화
    }

    //매니저만 호출할 수 있는 modifier
    //매니저인지 확인 후 함수 실행
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    //모든 플레이어 목록을 반환하는 함수
    function getPlayers() public view returns(address payable[] memory){
        return players;
    }

}