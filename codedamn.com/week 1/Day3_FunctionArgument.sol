// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract FunctionArgument{
 uint num =10;
 
 function set(uint _item) public {
  num=_item;
 }
 function get() public view returns(uint){
 return num;
 }
}
