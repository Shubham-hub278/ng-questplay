// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {

    uint256 immutable _SKIP;

    constructor(uint256 skip) {
        _SKIP = skip;
    }

    /** 
     * @notice Returns the sum of the elements of the given array, skipping any SKIP value.
     * @param array The array to sum.
     * @return sum The sum of all the elements of the array excluding SKIP.
     */
    function sumAllExceptSkip(
        uint256[] calldata array
    ) public view returns (uint256 sum) {

        // IMPLEMENT HERE
        //The _SKIP value is a storage variable and
        //reading in memory variable requires lesser gas than the _SKIP value again and again.
        uint256 s = _SKIP;

        uint256 value;
        uint256 cached= array.length;
        for(uint256 i; i < cached;){
                value = array[i];
                if(value != s) 
                    sum = sum + value;   
                unchecked {
                    ++i;
                }
        }
    }    

}
