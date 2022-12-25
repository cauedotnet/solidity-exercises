// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Day5 {
   
   function palindrome(uint256 n) public pure returns(uint256){
   
        uint256 reversed = 0;
        uint256 original=n;

        while(n != 0){
        
            reversed = reversed * 10 + (n%10);
            n /= 10;
        }

        return (reversed == original)?1:0;
   }
}
