// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Create2Upgradeable.sol";

contract EulerDAO is Initializable, OwnableUpgradeable, ERC721Upgradeable {
    address[] public problems;
    uint256[] public targets;
    bytes32[] public digests;
    address[] public solutions;
    uint256[] public scores;
    mapping(bytes32 => uint256) timestamps;
    mapping(bytes32 => address) challengers;

    function initialize() public initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        __ERC165_init_unchained();
        __ERC721_init_unchained("Euler Winner", "EULAR");
    }

    function register_problem(address problem) external onlyOwner {
        problems.push(problem);
    }

    function lock_solution(uint256 target, bytes32 digest) public {
        _mint(msg.sender, targets.length);
        targets.push(target);
        digests.push(digest);
        solutions.push(address(0));
        scores.push(0);
    }

    function submit_code(uint256 id, bytes memory code) external payable {
        address addr = Create2Upgradeable.deploy(0, bytes32(targets[id]), code);
        bytes32 digest;
        assembly {
            digest := extcodehash(addr)
        }
        require(digest == digests[id]);
        solutions[id] = addr;
    }

    function compete(uint256 id, uint256 score) external payable {
        require(msg.value >= cost(score));
        require(msg.sender == ownerOf(id));
        scores[id] = score;
    }

    function lock_challenge(bytes32 digest) public {
        require(timestamps[digest] + 10 minutes < block.timestamp);
        timestamps[digest] = block.timestamp;
        challengers[digest] = msg.sender;
    }

    function challenge(uint256 id, bytes calldata i) external payable {
        require(challengers[keccak256(i)] == msg.sender);
        uint256 gas = scores[id];
        require(gas > 0);
        (bool ok, bytes memory o) = solutions[id].staticcall{gas: gas}(i);
        if (ok && I(problems[targets[id]]).check(i, o)) {
            return;
        }
        scores[id] = 0;
        uint256 money = cost(gas) - cost(0) / 2;
        payable(msg.sender).transfer(money);
    }

    function get_addr(uint256 tgt, bytes32 h) external view returns (address) {
        return Create2Upgradeable.computeAddress(bytes32(tgt), h);
    }

    function cost(uint256 gl) internal pure returns (uint256) {
        return 40 * 1e9 * gl + 1e18;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://eulerdao.github.io/solutions/";
    }
}

interface I {
    function check(bytes calldata, bytes calldata) external view returns (bool);
}
