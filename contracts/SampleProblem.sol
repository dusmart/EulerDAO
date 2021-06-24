// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

import "hardhat/console.sol";

library SampleProblem {
    function check(bytes calldata i, bytes calldata o)
        external
        pure
        returns (bool)
    {
        require(bytes4(i[:4]) == 0x6d5433e6);
        (uint256 x, uint256 y) = abi.decode(i[4:], (uint256, uint256));
        uint256 z = abi.decode(o, (uint256));
        require(z >= x);
        require(z >= y);
        return true;
    }
}
