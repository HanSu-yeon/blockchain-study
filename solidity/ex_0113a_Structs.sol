/*
- 구조체(struct)를 사용하여 자신만의 유형을 정의할 수 있음
- 구조체는 관련 데이터를 함께 그룹화할 때 유용함
- 구조체는 컨트랙트 외부에 선언하고 다른 컨트랙트에서 가져올 수 있음
*/

// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//구조체를 이용해 할 일 목록을 관리하는 간단한 예제
contract Todos{

    struct Todo{
        string text; //할 일의 내용
        bool completed; //완료 여부
    }
    //Todo 구조체 배열로, 여러 개의 할 일 항목 저장
    //public이니 getter함수 자동 생성
    Todo[] public todos;

    //할 일 생성 함수
    function create(string memory _text) public {
        //세 가지 방법으로 구조체 초기화 및 배열에 추가하기 
        //1. 함수처럼 호출하여 바로 push
        todos.push(Todo(_text, false));
        //2. key-value 방식으로 push
        todos.push(Todo({text: _text, completed: false}));
        //3. 빈 구조체를 생성 후 값을 할
        Todo memory todo;
        todo.text = _text;
        todos.push(todo);
    }
    //할 일 조회 함수
    function get(uint256 _index)
        public 
        view 
        returns (string memory text, bool completed)
    {   
        //특정 인덱스 위치에 있는 할 일을 반환
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }
    //할 일 텍스트 수정 함수
    function updateText(uint _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }
    //완료 상태 토글 함
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}
