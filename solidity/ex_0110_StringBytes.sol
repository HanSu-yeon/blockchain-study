// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract StringBytes{
    string myString = "Ethereum";

    function getLength(string memory _name) public pure returns(uint _length){
        bytes memory temp = bytes(_name); //String을 bytes로 변환
        _length = temp.length;
    }

    function getElementAt(uint _i) public view returns (bytes1 _letter){
        bytes memory temp = bytes(myString);
        _letter = temp[_i]; //i번째 위치한 문자를 16진수로 리턴
    }

    function getElementAt2(uint _i) public view returns (string memory _letter){
        bytes memory temp = bytes(myString);
        _letter = string (abi.encodePacked(temp[_i])); //문자열로 리턴
    }
}