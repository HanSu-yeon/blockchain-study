// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//추상계약 Pet
//두 개의 추상 함수와 하나의 구현된 함수 포함
//추상함수는 상속받는 계약에서 반드시 구현되어 함
abstract contract Pet{

    string internal name;
    uint internal age;

    constructor (string memory _name, uint _age){
        name = _name;
        age = _age;
    }

    function getProperties() public view virtual returns(string memory, uint);
    function sound() public view virtual returns(string memory);
    function doMath(uint _a, uint _b) public pure returns(uint){
        return _a + _b;
    }
}

contract Dog is Pet{

    constructor(string memory _name, uint _age) Pet(_name, _age){}

    
    function getProperties() public view override returns(string memory, uint){
        return (name, age);
    }
    function sound() public view override returns(string memory){
        return string(abi.encodePacked(name, "is a dog..mung"));
    }
}


contract Cat is Pet{

    constructor(string memory _name, uint _age) Pet(_name, _age){}

    
    function getProperties() public view override returns(string memory, uint){
        return (name, age);
    }
    function sound() public view override returns(string memory){
        return string(abi.encodePacked(name, "is a cat...meow"));
    }
}



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

    function dogDoMath(uint _i, uint _a, uint _b) public view returns (uint){
        require(_i < counterDog, "Index out of bounds!");
        return (dogs[_i].doMath(_a, _b));
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

    function catDoMath(uint _i, uint _a, uint _b) public view returns (uint){
        require(_i < counterCat, "Index out of bounds!");
        return (cats[_i].doMath(_a, _b));
    }
}



