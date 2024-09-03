// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract TryCatchEx{

    uint[] myArray;

    event catchError(string _name, string _err);
    event catchPanic(string _name, uint256 _err);
    event catchLowLevelError(string _name, bytes _err);

    function tryCatchTest(uint _x, uint _y) public returns(uint, bool){
        try this.errFunction(_x, _y) returns(uint _res){
            return(_res, true);
        }catch Error(string memory _error){
            emit catchError("Require error!", _error);
            return(0, false);
        }catch Panic(uint _errorCode){
            emit catchPanic("Assert or Panic error1", _errorCode);
            return (0, false);
        }
        catch(bytes memory _errorCode){
            emit catchLowLevelError("Low level error (Revert)!", _errorCode);
            return(0, false);
        }
    }

    function errFunction(uint _x, uint _y) public returns (uint){
        require(_x != 1, "Require failed!");

        assert(_x != 2);

        if(_x == 3){ revert();}

        myArray.push(1);
        myArray.pop();
        // myArray.pop();  //Panic Errcode 49(0x31)

        return _x/_y; //4,0 대입시 Panic Errcode 18(0x12)
    }
}