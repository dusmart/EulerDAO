// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

library SampleSolution {
    function max(uint256 a, uint256 b) external pure returns (uint256) {
        return a >= b ? a : b;
    }
}
