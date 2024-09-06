// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//Counter 라이브러리
library Counters{
    //카운터의 현재 값을 저장하는 구조체
    struct Counter {
        uint256 _value;
    }

    //Counter의 현재 값을 반환하는 함수
    //storage 키워드를 사용해 참조를 전달받고, 이 참조를 통해 Counter의 값을 읽음
    //view로 상태 변경이 없음을 보장함
    function current(Counter storage x) internal view returns(uint256){
        return x._value;
    }

    //Counter의 값을 1씩 증가시키는 함수
    function increment(Counter storage x) internal {
        //unchecked 블록을 사용하여 오버플로우 체크를 생략 -> 가스 절약
        //※0.8.x 이후 오버플로우/언더플로우가 기본적으로 체크됨 -> 불필요할시 unchecked를 사용해 성능 향상시킴
        unchecked{
            x._value += 1;
        }
    }

    //Counter의 값을 1씩 감소시키는 함수
    function decrement(Counter storage x) internal {
        uint256 value = x._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            x._value = value - 1;
        }
    }

    function reset(Counter storage x) internal {
        x._value = 0;
    }
}

contract TestLibrary {
    //Counters 라이브러리 사용 
    using Counters for Counters.Counter;
    //Counters.Counter 타입의 변수 선언하여 카운터 기능 
    Counters.Counter private myID;

    function getCurrent() public view returns (uint256) {
        return myID.current();
    }

    function increment() public {
        myID.increment();
    }

    function decrement() public {
        myID.decrement();
    }

    function reset() public {
        myID.reset();
    }
}