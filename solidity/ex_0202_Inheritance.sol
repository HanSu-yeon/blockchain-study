// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//상속 예제
/*
상속을 이용해 코드의 재사용성을 높임
Pet이라는 부모 계약에서 파생된 Dog, Cat이라는 자식 계약을 만들어 사용하는 예제
상속을 통해 자식 계약은 부모 계약의 속성과 함수를 사용할 수 있고 추가적인 기능을 구현할 수 있음
*/
contract Pet{
    //internal이니까 자식 계약에서 접근 가능
    string internal name;
    uint internal age;

    constructor(string memory _name, uint _age){
        name = _name;
        age = _age;
    }

    function getProperties() public view returns (string memory, uint){
        return (name, age);
    }
}

//Pet 상속받아 Dog 계약 생성
//부모 계약(Pet)의 모든 속성과 함수를 사용할 수 있음 -> 코드 재사용성 높아지고, 중복 코드 줄임
contract Dog is Pet{
    //Dog 계약(자식)의 생성자에서는 부모 계약인 Pet의 생성자를 호출하여 _name, _age 초기화
    //이때 부모 계약의 생성자를 호출하는 것은 필수적
    constructor (string memory _name, uint _age) Pet(_name, _age){
    }

    function bark() public view returns (string memory){
        return string(abi.encodePacked(name, " is a dog...barking..."));
    }
}

//Pet 상속받아 Cat 계약 생성
contract Cat is Pet{
    //여기서도 부모 계약(Pet)의 생성자를 호출하여 _name, _age 초기화
    //자식계약이 생성될 때, 부모 계약의 생성자를 호출하여 초기화 작업 수행
    constructor (string memory _name, uint _age) Pet(_name, _age){
    }

    function meow() public view returns (string memory){
        return string(abi.encodePacked(name, " is a cat...meowing..."));
    }
}

//Dog, Cat의 인스턴스를 생성하고 관리하는 역할
contract TestInstance{

    Dog[] dogs;
    Cat[] cats;
    uint counterDog = 0;
    uint counterCat = 0;

    function addDog(string memory _name, uint _age) public {
        Dog dog = new Dog(_name, _age);
        dogs.push(dog);
        counterDog++;
    }

    function getDog(uint _i) public view returns(string memory, uint){
        require(_i < counterDog, "Index out of bounds!");
        return (dogs[_i].getProperties());
    }

    function bark(uint _i) public view returns(string memory){
        require(_i < counterDog, "Indx out of bounds!");
        return (dogs[_i].bark());
    }

    function addCat(string memory _name, uint _age) public{
        Cat cat = new Cat(_name, _age);
        cats.push(cat);
        counterCat++;
    }

    function getCat(uint _i) public view returns (string memory, uint){
        require(_i < counterCat, "Index out of bounds!");
        return (cats[_i].getProperties());
    }

    function meow(uint _i) public view returns(string memory){
        require(_i < counterCat, "Index out of bounds!");
        return(cats[_i].meow());
    }
}