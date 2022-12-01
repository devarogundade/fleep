// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {PriceApi} from "./PriceApi.sol";
import {Swap} from "./Swap.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Sweeper {
    Swap private _swap;

    address private _deployer;

    uint256 private DUST_THRESHOLD;

    // === Events === //

    event FleepSweeped(uint256 amount, address from, uint timestamp);

    // initialize dependencies
    constructor(address swap) {
        _swap = Swap(swap);
        _deployer = msg.sender;
        DUST_THRESHOLD = inWei(20);
    }

    // recursively swap every tokens for MATIC
    function sweep(address[] memory tokens) public returns (uint256) {
        uint256 amount1;
        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            IERC20 token = IERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(msg.sender);

            // amount cannot be lesser than 100 WEI
            if (amount0 < 100) continue;

            // swap
            amount1 += _swap.swap(
                tokens[index],
                _swap.getNativePair(),
                amount0
            );
        }

        // registers every successful sweeps
        emit FleepSweeped(amount1, msg.sender, block.timestamp);

        return amount1;
    }

    function estimate(
        address[] memory tokens,
        address wallet
    ) public view returns (uint256) {
        uint256 amount1;

        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            IERC20 token = IERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(wallet);

            amount1 += _swap.estimate(
                tokens[index],
                _swap.getNativePair(),
                amount0
            );
        }

        return amount1;
    }

    function findDusts(
        address[] memory tokens,
        address wallet
    ) public view returns (address[] memory) {
        address[] memory dusts;

        for (uint index = 0; index < tokens.length; index++) {
            IERC20 _token = IERC20(tokens[index]);

            // fetching the balance of the erc20
            uint256 amount0 = _token.balanceOf(wallet);

            // amount cannot be lesser than 100 WEI
            if (amount0 < 100) continue;

            // skip if token address points to MATIC
            if (tokens[index] == _swap.getNativePair()) continue;

            // fetching price of the token in usdt
            uint256 amount1 = _swap.estimate(
                tokens[index],
                _swap.getUSDTPair(),
                amount0
            );

            // checking is token is a dust
            // i.e has a value lower than threshold
            if (amount1 <= DUST_THRESHOLD) {
                dusts[dusts.length] = tokens[index];
            }
        }

        return dusts;
    }

    function inWei(uint256 amount) private pure returns (uint256) {
        return amount * 10 ** 18;
    }

    function updateDUSTThreshold(uint256 amount) public onlyDeployer {
        DUST_THRESHOLD = amount;
    }

    modifier onlyDeployer() {
        require(msg.sender == _deployer, "Only Deployer");
        _;
    }
}
