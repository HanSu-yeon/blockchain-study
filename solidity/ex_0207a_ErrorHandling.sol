// SPDX-License-Identifier: MIT

//오류 처리 예시
/*
오류가 발생하면 트랜잭션 중에 상태(state)에 적용된 모든 변경 사항이 취소됨
require,v revert, assert를 호출하여 오류를 발생시킬 수 있음

- require: 실행 전 입력과 조건의 유효성을 검사하는데 사용됨
- revert: require와 유사.
- assert: 절대 거짓이어서는 안 되는 코드를 확인하는데 사용됨. assertion에 실패하면 버그가 있다는 뜻일 수 있다.

사용자 정의 오류를 사용하여 가스를 절약해라
*/
pragma solidity >=0.7.0 <0.9.0;

contract ErrorHandling{

    //입력값이 10 이하면 tx 중단
    function testRequire(uint256 _i) public pure{
        //require는 다음과 같은 조건을 검증하는 데 사용됨:
        //- 입력값 검증
        //- 실행 전 조건 검증
        // - 다른 함수 호출의 반환값 검증    
        require(_i > 10, "input must be greter than 10");
    }

    //이 함수에서는 require와 동일한 동작을 수행하지만, 조건을 검증할 때 revert를 사용하여 tx 중단함
    function testRevert(uint256 _i) public pure{
        //revert는 복잡한 조건 검증할 때 유용
        if(_i <=10){
            revert("input must be greater than 10");
        }
    }

    uint256 public num;
    //Assert는 내부 오류를 테스트하거나, 불변 조건(ex.코드 내에서 항상 참이어야 한다)을 검사하는 데만 사용해야 함
    //num이 항상 0이어야 한다고 가정하고 그렇지 않을 경우 tx 중단
    function testAssert() public view{
        //num의 값을 변경할 수 없기 때문이 이 조건은 항상 참
        assert(num == 0);
    }

    //사용자 정의 오류(custom error)를 사용하여 오류 메시지를 더욱 효율적으로 처리함
    //smartcontract의 잔액이 _withdrawAmount(인출금액)보다 적다면 InsufficientBalance 오류 발생시킴
    //custom error는 가스를 절약하고 구조화된 오류 처리가 가능
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view{
        uint bal = address(this).balance;
        if(bal < _withdrawAmount){
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}

