// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//OpenZepplin 라이브러리 활용

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol"; 

contract ERC20TokenCustom is ERC20 {
    constructor(string memory _name, string memory _symbol, uint _amount) ERC20(_name, _symbol){
        _mint(msg.sender, _amount*100**uint(decimals()));
    }
}