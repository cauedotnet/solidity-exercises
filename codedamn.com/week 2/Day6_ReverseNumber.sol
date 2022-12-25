// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Day6 {
    
    function reverseDigit(uint256 n) public pure returns(uint256){
    
        uint256 result = 0;

        while(n!=0){
        
            result = result * 10 + (n%10);
            n /= 10;
        }

        return result;
    }
}
