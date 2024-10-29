// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VendingMachine{
    event Purchase (address indexed purchaser, uint256 amount);

    address public owner; //자판기 소유자 주소
    mapping(address=>uint) public cupcakeBalances;//구매자별 보유량
    uint public stockBalance; //컵케이크 재고

    constructor(){
        owner = msg.sender; //배포자를 자판기 소유자로 설정
        stockBalance =100; //초기 재고 설정
    }
    
    //재고 보충 함수
    function refill(uint amount) public {
        require(msg.sender == owner,"Only the owner can refill.");
        stockBalance +=amount;
    }
    //구매 함수
    function purchase(uint amount) public payable{
        require(msg.value >= amount * 1 ether, "You must pay at least 1 ETH per cupcake");
        require(stockBalance >= amount, 'Not enough cupcakes in stock to complete this purchase');
        stockBalance -= amount;
        cupcakeBalances[msg.sender]+=amount;
        emit Purchase(msg.sender, amount);
    }
}