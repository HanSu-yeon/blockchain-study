// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//인터페이스는 다른 계약에서 구현해야 하는 함수의 서명을 정의하는 추상 계약
//-> 다른 계약들이 이 인터페이스를 준수하도록 강제할 수 있음
interface Pet{

    //추상함수(함수 구현 포함x)
    function getProperties() external view returns(string memory, uint); 
    function sound() external view returns(string memory);
}

//인터페이스를 구현하는 계약
contract Dog is Pet{
    string private name;
    uint private age;

    constructor(string memory _name, uint _age){
        name = _name;
        age = _age;
    }

    //인터페이스에서 정의된 대로 함수 구현
    function getProperties() public view override returns(string memory, uint){
        return(name, age);
    }

    function sound() public view override returns(string memory){
        return string(abi.encodePacked(name, " is a dog..mung.."));
    }
}

contract Cat is Pet{
    string private name;
    uint private age;

    
    constructor(string memory _name, uint _age){
        name = _name;
        age = _age;
    }

    //함수 구현
    function getProperties() public view override returns(string memory, uint){
        return(name, age);
    }

    function sound() public view override returns(string memory){
        return string(abi.encodePacked(name, " is a cat..meow.."));
    }
}

// 실제로 전개될 계약
// 인터페이스를 통해 서로 다른 구현체(Dog, Cat)를 동일한 방식으로 처리할 수 있음
contract TestInstance {
    Dog[] dogs;
    Cat[] cats;
    uint counterDog = 0;
    uint counterCat = 0;

    function addDog(string memory _name, uint _age) public {
        Dog dog = new Dog(_name, _age);
        dogs.push(dog);
        counterDog++;
    }

    function getDog(uint _i) public view returns (string memory, uint){
        require(_i < counterDog, "Index out of bounds!");
        return (dogs[_i].getProperties());
    }

    function bark(uint _i) public view returns (string memory){
        require(_i < counterDog, "Index out of bounds!");
        return (dogs[_i].sound());
    }

    function addCat(string memory _name, uint _age) public {
        Cat cat = new Cat(_name, _age);
        cats.push(cat);
        counterCat++;
    }

    function getCat(uint _i) public view returns (string memory, uint){
        require(_i < counterCat, "Index out of bounds!");
        return (cats[_i].getProperties());
    }

    function meow(uint _i) public view returns (string memory){
        require(_i < counterCat, "Index out of bounds!");
        return (cats[_i].sound());
    }
}


