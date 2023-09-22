// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Challenge {

    /**
     * @notice Returns a copy of the given array in a gas efficient way.
     * @dev This contract will be called internally.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function copyArray(bytes memory array) 
        internal 
        pure 
        returns (bytes memory copy) 
    {

    assembly {

        // Get a location of some free memory and store it in copy array as
            copy := mload(0x40)
        // Store the length of the array bytes array at the beginning of
        // the memory for copy arrat.
            let length := mload(array)
            mstore(copy, length)

        // Maintain a memory counter for the current write location in the
        // copy bytes array by adding the 32 bytes for the array length to
        // the starting location.
            let mc := add(copy, 0x20)
        
        // Stop copying when the memory counter reaches the length of the
        // array bytes array.
            let end := add(mc, length)

            for {
            // Initialize a copy counter to the start of the array data,
            // 32 bytes into its memory.
                let cc := add(array, 0x20)
            } lt(mc, end) {
            // Increase both counters by 32 bytes each iteration.
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
            // Write the _preBytes data into the tempBytes memory 32 bytes
            // at a time.
                mstore(mc, mload(cc))
            }
            //update free-memory pointer
            //allocating the array padded to 32 bytes
            mstore(0x40, and(add(mc, 31), not(31)))   
    }
    }
   
}
