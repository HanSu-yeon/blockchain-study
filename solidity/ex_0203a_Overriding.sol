// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;


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

    //virtual로 선언되어 자식 계약에서 오버라이딩할 수 있
    function talk() public view virtual returns (string memory){
        return string(abi.encodePacked(name, " is a pet."));
    }
}

//Dog는 Pet 상속받
contract Dog is Pet {
     //자식 계약에서 부모 계약의 생성자를 호출하여 이름과 나이 초기화
    constructor(string memory _name, uint _age) Pet(_name, _age){
    }
    //부모 계약의 talk()함수 오버라이
    function talk() public view virtual override  returns (string memory){
        return string(abi.encodePacked(name, " is a dog."));
    }
}

//Dog의 자식계약으로 Dog 계약을 상속받음
contract ShiTzu is Dog{

    constructor(string memory _name, uint _age) Dog(_name, _age){
    }

    //Dog 계약의 talk()함수를 오버라이딩 
    function talk() public view override returns (string memory){
        return string(abi.encodePacked(name, "is a shitzu."));
    }
}
contract TestInstance {
    Pet aPet = new Pet("pet", 3);
    Dog aDog = new Dog("dog", 5);
    ShiTzu aShiTzu = new ShiTzu("shitzu",2);

    //다형성 활용
    Pet aPet2 = new Pet("pet2", 3);
    Pet aDog2 = new Dog("dog2", 5);
    Pet aShiTzu2 = new ShiTzu("shitzu2",2);

    function talkPet() public view returns (string memory){
        return (aPet.talk());
    }

    
    function talkDog() public view returns (string memory){
        return (aDog.talk());
    }

    
    function talkShiTzu() public view returns (string memory){
        return (aShiTzu.talk());
    }

    function talkPet2() public view returns (string memory){
        return (aPet2.talk());
    }

    
    function talkDog2() public view returns (string memory){
        return (aDog2.talk());
    }

    
    function talkShiTzu2() public view returns (string memory){
        return (aShiTzu2.talk());
    }

}