// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {PriceApi} from "./PriceApi.sol";
import {FleepSwap} from "./FleepSwap.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FleepSweeper {
    FleepSwap private _fleepSwap;

    // registers every successful swap
    event FleepSweeped(
        uint256 amount,
        uint256 amountOut,
        address from,
        uint timestamp
    );

    constructor(address fleepSwap) {
        _fleepSwap = FleepSwap(fleepSwap);
    }

    function sweep(address[] memory tokens)
        public
        returns (uint256)
    {
        uint256 amount1;
        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            IERC20 token = IERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(msg.sender);

            amount1 += _fleepSwap.swap(
                tokens[index],
                _fleepSwap.getNativePair(),
                amount0
            );
        }

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

            IERC20 token = IERC20(tokens[index]);
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
