// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Day3 {
  
      function prime(uint256 n) public pure returns(uint256){
      
        if (n > 1){
            for (uint256 i = 2; i < n / 2; i++) {

                if (n % i == 0) {
                    return 0;
                    break;
                }
            }
        }
        
        return 1;
      }
}
