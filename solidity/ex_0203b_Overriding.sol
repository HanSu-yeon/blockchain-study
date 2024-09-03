// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/*
상속과 오버라이딩을 활용한 예제
*/

//부모 계약으로, 반려동물의 기본 정보를 저장하고 반려동물이 내는 소리를 정의
contract Pet{
    string internal name;
    uint internal age;
    
    constructor(string memory _name, uint _age){
        name = _name;
        age = _age;
    }

    function getProperties() public view returns (string memory, uint){
        return (name, age);
    }
    //부모 계약의 sound() 함수를 오버라이딩하여, 개 짖는 소리를 반환하도록 변경
    function sound() public view virtual returns (string memory){
        return "...";
    }
}

contract Dog is Pet {
    //자식 계약에서 부모 계약의 생성자를 호출하여 이름과 나이 초기화
    constructor(string memory _name, uint _age) Pet(_name, _age){
    }

    function sound() public view override returns (string memory){
        return string(abi.encodePacked(name, " is a dog... barking..."));
    }
}

contract TestInstance {
    Dog[] dogs;
    uint counter = 0;

    function addDog(string memory _name, uint _age) public{
        Dog dog = new Dog(_name, _age);
        dogs.push(dog);
        counter++;
    }

    function getDog(uint _i) public view returns(string memory, uint){
        require(_i < counter, "Index out of bounds");
        return (dogs[_i].getProperties());
    }

    function bark(uint _i) public view returns(string memory){
        require(_i < counter, "Index out of bounds");
        return (dogs[_i].sound());
    }
}