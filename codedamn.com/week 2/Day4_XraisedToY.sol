// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Day4 {
    
    function power(uint256 x, uint256 y) public pure returns(uint256){
    
        uint256 result = x;

        for(uint256 c=1; c<y;c++){
        
            result *= x;
        }

        return result;
    }
}
