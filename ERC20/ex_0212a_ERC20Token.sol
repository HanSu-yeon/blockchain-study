// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//ERC-20 표준을 따르는 토큰 발행 예시로 직접 코딩하여 모든 함수들을 구현

contract ERC20Token {

    string public name = "Hansu Token";
    string public symbol = "TST";
    uint8 private _decimals = 18; //토큰의 소수점 자리수
    uint private _totalSupply; //총 발행량. 생성자 함수에서 설정됨

    //각 계정이 소유한 토큰의 잔고를 저장하는 mapping
    mapping (address => uint) balances;
    //토큰 소유자가 대리인에게 허락한토큰 양을 관리하는 mapping
    mapping (address =>mapping(address=>uint256)) allowance;

    //토큰이 송금될 때 발생하는 이벤트 -> 이벤트는 트랜잭션 로그로 남아 이후에 블록체인에서 확인할 수 있음
    event Transfer(address indexed _from, address indexed _to, uint _tokens);
    //토큰 소유자가 대리인(_spender)에게 특정 양의 토큰을 송금할 수 있도록 허락할 때 발생하는 이벤트
    event Approval(address indexed _tokenOwner, address indexed _spender, uint _tokens);

    //컨트랙트가 배포될 떄 호출
    constructor (uint _amount){
        //소수점 단위를 포함하여 설정됨 ex. 1000개의 토큰 발행 -> 1000 * 10^18
        _totalSupply = _amount*(10**_decimals);
        //msg.sender에게 _totalSupply 만큼의 토큰을 할당함
        balances[msg.sender] = _totalSupply;
    }

    //토큰의 소수점 자리수 반환 -> 대부분의 ERC20 토큰은 18자리 사용
    function decimals() public view returns(uint){
        return _decimals;
    }
    //현재 유통 중인 총 토큰 양 반환
    function totalSupply() public view returns(uint){
        return _totalSupply;
    }
    //특정 주소(_tokenOwner)가 소유한 토큰의 잔고를 반환
    function balanceOf(address _tokenOwner) public view returns (uint){
        return balances[_tokenOwner];
    }
    //현재 계정의 토큰을 다른 계정(_to)으로 송금
    function transfer(address _to, uint _tokens) public returns (bool){
        balances[msg.sender] -= _tokens;
        balances[_to] += _tokens;
        //송금 후, Transfer 이벤트 발생
        emit Transfer(msg.sender, _to, _tokens);
        return true;
    }

    //토큰 소유자가 대리인(_spender)에게 _tokens 만큼의 토큰을 대신 송금할 수 있도록 허락함
    function approve(address _spender, uint _tokens) public returns (bool){
        allowance[msg.sender][_spender] = _tokens;
        //허락 후 Approval 이벤트가 발생함
        emit Approval(msg.sender, _spender, _tokens);
        return true;
    }

    //대리인이 _from의 토큰을 _to로 송금함
    //대리인 계정은 approve 함수를 통해 허락된 만큼만 송금할 수 있다
    function transferFrom(address _from, address _to, uint _tokens) public returns(bool){
        balances[_from] -= _tokens;
        allowance[_from][msg.sender] -= _tokens;
        balances[_to] += _tokens;
        emit Transfer(_from, _to, _tokens);
        return true;
    }


}
