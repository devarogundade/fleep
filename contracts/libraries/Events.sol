// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

library Events {
    event LiquidProvided(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        address provider,
        uint timestamp
    );

    event FleepSwaped(
        uint256 amount,
        uint256 amountOut,
        address from,
        address to,
        uint timestamp
    );

    event FleepSweeped(uint256 amount, address from, uint timestamp);
}
