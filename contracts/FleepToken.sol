// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {ERC20} from "./standard/ERC20.sol";

contract FleepToken is ERC20 {
    uint256 private MAX_ALLOCATION = inWei(50);

    // user address => minted amount
    mapping(address => uint256) public allocations;

    constructor() ERC20("Fleep Token", "FLP") {
        _mint(msg.sender, inWei(50000000));
        _mint(address(this), inWei(50000000));
    }

    // faucet minting for testing purposes
    function faucet(uint256 amount) public {
        require(amount > 0, "Amount cannot be zero");
        require(
            allocations[msg.sender] + amount < MAX_ALLOCATION,
            "Cant Mint More Tokens"
        );
        allocations[msg.sender] += amount;
        _approve(address(this), msg.sender, amount);
        transferFrom(address(this), msg.sender, amount);
    }

    function inWei(uint256 amount) public view returns (uint256) {
        return amount * 10**decimals();
    }
}
