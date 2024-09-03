// SPDX-License-Identifier: GPL-3.0

//정적 바이트 배열
pragma solidity >=0.7.0 <0.9.0;

contract StaticBytes{
    //Storage 정적 바이트 배열
    bytes5 storageBytes5 = "Hello"; 
    bytes3 storageBytes3 = 0xaabbcc; //16진수 대입

    function testBytes() public pure returns(bytes1){
        
        bytes2 localBytes2; //정적 바이트니까 memory 키워드 필요x
        localBytes2 = 0xffff; //정적바이트 값 대입
        
        localBytes2 = "a"; //정적 local 바이트 배열에 재할당 가능

        bytes3 localBytes3 = 0xabcdff;
        localBytes3 = localBytes2; //작은 바이트에서 큰 바이트로 대입 가능

        //TypeError: Single bytes in fixed bytes arrays cannot be modified.
        //localBytes3[1] = 0x11; //인덱싱하여 대입 불가능. 부분적 변경 불가능

        //return값: 0x61
        //"a"는 ASCII 코드로 0x61
        //localBytes3 = 0x610000 => 첫번째 바이트는 0x61
        return localBytes3[0]; //인덱싱하여 읽는 것은 가능
        
    }

}