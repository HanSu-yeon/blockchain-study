// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//Instance 예시
/*
객체지향 프로그래밍의 개념을 활용하여 다른 계약의 인스턴스를 생성하고 관리하는 예제
Dog라는 계약을 만들고, 이를 인스턴스화하여 여러 개의 Dog객체를 TestInstance 계약에서 관리할 수 있도록 함

Dog 계약은 개체(인스턴스)의 속성을 정의하고, 개체의 동작을 정의함
*/
contract Dog {

    //속성
    string private name;
    uint private age;

    //계약 배포될 때 name, age 받아 초기화
    constructor(string memory _name, uint _age){
        name = _name;
        age = _age;
    }
    
    //개체의 이름, 나이 반환하는 함수
    function getProperties() public view returns (string memory, uint){
        return (name, age);
    }
    //개체가 짖는 동작을 하는 메시지 반환
    function bark() public view returns (string memory){
        return string(abi.encodePacked(name, "is barking ... mungmung.."));
    }
}

// 이 계약은 여러 Dog 계약의 인스턴스를 생성하고 관리하는 역할을 함
contract TestInstance{

    //속성
    Dog[] dogs; //Dog 인스턴스의 배열로 계약이 관리하는 모든 Dog인스턴스를 저장함
    uint private counter = 0; //dogs 배열의 길이 추적

    //새로운 Dog인스턴스 생성, dogs 배열에 추가
    function addDog(string memory _name, uint _age) public {
        Dog dog = new Dog(_name, _age); //name, age를 인수로 받아 새로운 개체 생성 
        dogs.push(dog);
        counter++;
    }

    //특정 인덱스에 있는 Dog의 이름과 나이 반환
    function getDog(uint _i) public view returns (string memory, uint){
        //인덱스가 counter보다 크거나 같으면 오류 발생
        require(_i < counter, "Index out of bounds!");
        return (dogs[_i].getProperties());
    }

    //dogs 배열에 저장된 Dog 인스턴스의 수 반환
    function getCounter() public view returns(uint){
        return counter;
    }
}