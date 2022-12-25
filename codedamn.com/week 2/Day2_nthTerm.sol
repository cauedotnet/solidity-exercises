// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Day2 {
    
    function nthTerm(uint256 n, uint256 a, uint256 b, uint256 c) public pure returns(uint256){

        uint256 result = 0;
        
        if ( n == 1 ) {  result = a; }
        else if ( n == 2 ) {  result = b; }
        else if ( n == 3 ) {  result = c; }
        else { result = nthTerm(n-1,a,b,c) + nthTerm(n-2,a,b,c) + nthTerm(n-3,a,b,c);}

        return result;
    }

}
