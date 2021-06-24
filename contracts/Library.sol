// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

library Library {
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }
}
