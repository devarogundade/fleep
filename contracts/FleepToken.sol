// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FleepToken is ERC20 {
    uint256 private MAX_ALLOCATION = 50 * 10**decimals();

    // user address => minted amount
    mapping(address => uint) public allocations;

    constructor() ERC20("Fleep Token", "FLP") {
        _mint(msg.sender, 50000000 * 10**decimals());
        _mint(address(this), 50000000 * 10**decimals());
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

    function getDecimals() public view returns (uint256) {
        return 10**decimals();
    }
}
