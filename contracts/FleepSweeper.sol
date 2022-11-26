// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {PriceApi} from "./PriceApi.sol";
import {FleepSwap} from "./FleepSwap.sol";
import {ERC20} from "./standard/ERC20.sol";

contract FleepSweeper {
    FleepSwap private _fleepSwap;

    // === Events === //

    event FleepSweeped(uint256 amount, address from, uint timestamp);

    // initialize dependencies
    constructor(address fleepSwap) {
        _fleepSwap = FleepSwap(fleepSwap);
    }

    // recursively swap every tokens for matic
    function sweep(address[] memory tokens) public returns (uint256) {
        uint256 amount1;
        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            ERC20 token = ERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(msg.sender);

            // amount cannot be lesser than 100 WEI
            if (amount0 < 100) continue;

            // swap
            amount1 += _fleepSwap.swap(
                tokens[index],
                _fleepSwap.getNativePair(),
                amount0
            );
        }

        // registers every successful sweeps
        emit FleepSweeped(amount1, msg.sender, block.timestamp);

        return amount1;
    }

    function estimate(address[] memory tokens, address wallet)
        public
        view
        returns (uint256)
    {
        uint256 amount1;

        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            ERC20 token = ERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(wallet);

            amount1 += _fleepSwap.estimate(
                tokens[index],
                _fleepSwap.getNativePair(),
                amount0
            );
        }

        return amount1;
    }
}
