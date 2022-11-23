// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestnetToken is ERC20 {
    uint256 private MAX_ALLOCATION = inWei(10000);

    // user address => minted amount
    mapping(address => uint) public allocations;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(address(this), inWei(10000000000));
    }

    // faucet minting for testing purposes
    function faucet(address minter, uint256 amount) public {
        require(amount > 0, "Amount cannot be zero");
        require(
            allocations[minter] + amount < MAX_ALLOCATION,
            "Cant Mint More Tokens"
        );
        allocations[minter] += amount;
        transfer(minter, amount);
    }

    function inWei(uint256 amount) private view returns (uint256) {
        return amount * 10**decimals();
    }
}
