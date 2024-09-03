// SPDX-License-Identifier: GPL-3.0

// 간단한 경매 시스템과 Event 예시
// 최고 입찰가가 나오면 이벤트를 발생시킴

pragma solidity >=0.7.0 <0.9.0;

contract BiddingEvent{

    // 경매 종료 시간을 저장하는 변수
    uint endingTime;

    // 입찰자 정보를 저장하는 구조체
    struct Bidder{
        address _address; // 입찰자의 이더리움 주소
        string _name;   // 입찰자의 이름
        uint _price;    // 입찰자가 제시한 입찰 금액
    }

    //현재가지 가장 높은 입찰가를 제시한입찰자의 정보를 저장하는 변수
    Bidder public highestBidder;

    //새로운 최고 입찰가가 제시될 때 발생하는 이벤트
    event NewHighPrice(address indexed who, string name, uint howmuch);

    //경매가 아직 종료되지 않았는지 확인하는 제어자
    modifier timeOut{
        if(block.timestamp < endingTime){
            _; //함수 실행을 계속 진행
        }else{
            revert(); //경매가 종료되었으므로 트랜잭션을 되돌림
        }
    }

    // 컨트랙트 배포 시 초기 설정을 수행하는 생성자 함수
    constructor(){
        highestBidder._price = 1 ether; //초기 초저 입찰가를 1 이더로 설정
        endingTime = block.timestamp + 1 minutes; //현재 시간으로부터 1분 후에 경매 종료
    }

    // 입찰자가 새로운 입찰가를 제시할 때 호출하는 함수
    function bid(string memory _name) public payable timeOut{
        // 새로운 입찰가가 현재 최고가보다 높은지 확인
        if(msg.value > highestBidder._price){
            highestBidder._address = msg.sender; // 입찰자의 주소를 저장
            highestBidder._name = _name;         //입찰자의 이름 저장
            highestBidder._price = msg.value;    //새로운 최고 입찰가를 저장
            emit NewHighPrice(msg.sender, _name, msg.value); //이벤트 발생
        }else{
            //제시된 입찰가가 현재 최고가보다 낮으면 입찰을거부하고 트랜잭션을 되돌림
            revert("bid not accepted!!!");
        }
    }

    //경매 종료까지 남은 시간을 반환하는 함수
    function timeRemaining() public view returns (uint){
        if(endingTime >= block.timestamp){
            return endingTime - block.timestamp; //남은 시간을 반환
        }else{
            return 0; //경매가 종료되었으면 0을 반환
        }
    }

}
