// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

// try-catch는 외부 함수 호출 및 계약 생성의 오류만 잡을 수 있다

// Foo 컨트랙트는 외부 호출 또는 새로운 컨트랙트를 생성할 때 발생할 수 있는 예외 상황을 만들기 위해 설계된 컨트랙트
contract Foo{
    address public owner;

    //_owner가 두 조건에 해당하지 않으면 _owner를 소유자로 설정
    constructor(address _owner){
        require(_owner != address(0), "invalid address");
        //_owner가 특정 주소일 때 오류를 발생시킴
        assert(_owner != 0x0000000000000000000000000000000000000001);
        owner = _owner;
    }

    function myFunc(uint256 x) public pure returns (string memory){
        require(x != 0, "require failed");
        return "my func was called";
    }
}

//Foo 컨트랙트를 외부에서 호출하고, 오류가 발생했을 때 이를 처리하기 위해 try/catch구문을 사용하는 예제
//외부 컨트랙트의 함수 호출하거나 새로운 컨트랙트를 생성할 때 발생할 수 있는 다양한 오류 처리하는 방법을 보여주는 예제
contract Bar {
    event Log(string message); //문자열 메시지를 기록하는 이벤트
    event LogBytes(bytes data); //바이트 데이터를 기록하는 이벤트

    //Foo 컨트랙트의 인스턴스를 저장하는 상태 변수
    Foo public foo;

    //Bar 컨트랙트의 생성자에서 Foo컨트랙트를 생성하고 소유자를 msg.sender로 설정
    constructor(){
        foo = new Foo(msg.sender);
    }

    //Foo컨트랙트의 myFunc함수를 호출하는 함수
    // tryCatchExternalCall(0) => Log("external call failed")
    // tryCatchExternalCall(1) => Log("my func was called")
    //오류가 발생하면 "external call failed" 메시지 기록
    function tryCatchExternalCall(uint256 _i) public {
        try foo.myFunc(_i) returns (string memory result){
            //함수 호출 성공하면 Log이벤트에 성공 메시지 기록
            emit Log(result);
        } catch{
            emit Log("external call failed");
        }
    }

    //새로운 Foo 컨트랙트를 생성하는 함수
    //생성 중 오류가 발생하면 그 이유를 기록함
    // tryCatchNewContract(0x0000000000000000000000000000000000000000) => Log("invalid address")
    // tryCatchNewContract(0x0000000000000000000000000000000000000001) => LogBytes("")
    // tryCatchNewContract(0x0000000000000000000000000000000000000002) => Log("Foo created")
    function tryCatchNewContract(address _owner) public {
      try new Foo(_owner) returns (Foo foo){
        //컨트랙트 생성 성공하면 메시지 기록
        emit Log("Foo created");
      }catch Error(string memory reason){
        //생성 중 require나 revert로 인한 오류가 발생하면 catch Error 블록 실행, 오류 메시지 기록
        emit Log(reason);
      }catch (bytes memory reason){
        //assert로 인한 오류가 발생하면 catch (bytes memory reason) 블록이 실행되어 원시 오류 데이터가 기록됨
        emit LogBytes(reason);
      }
    }
}