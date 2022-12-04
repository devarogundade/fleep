// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {Swap} from "./Swap.sol";
import {Events} from "../libraries/Events.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Sweeper {
    // dependecies
    Swap private _swap;

    address private _deployer;

    // dust price threshold
    uint256 private DUST_THRESHOLD;

    constructor(address swap) {
        _swap = Swap(swap);
        _deployer = msg.sender;

        // default is 20 USDT
        DUST_THRESHOLD = inWei(20);
    }

    // recursively swap every tokens for USDT
    function sweep(
        address[] memory tokens /* address destinationPair */
    ) public returns (uint256) {
        uint256 amount1;

        // TO DO for next iteration
        // user should able to choose the destination
        // asset but for now, you can only sweep to USDT
        address destinationPair = _swap.getUSDTPair();

        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            IERC20 token = IERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(msg.sender);

            // amount cannot be lesser than 100 WEI
            if (amount0 < 100) continue;
            // dust is already in destination assets
            if (tokens[index] == destinationPair) continue;

            // swap to USDT
            amount1 += _swap.doSwap(
                tokens[index],
                destinationPair,
                amount0,
                msg.sender
            );
        }

        // registers every successful sweeps
        emit Events.FleepSweeped(amount1, msg.sender, block.timestamp);

        return amount1;
    }

    function estimate(
        address[] memory tokens,
        address wallet /* address destinationPair */
    ) public view returns (uint256) {
        uint256 amount1;

        // TO DO for next iteration
        // user should able to choose the destination
        // asset but for now, you can only estimate for USDT
        address destinationPair = _swap.getUSDTPair();

        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            // skip if token address points to MATIC
            // Native coin (MATIC) is not considered as dust
            if (tokens[index] == _swap.getNativePair()) continue;

            IERC20 token = IERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(wallet);

            amount1 += _swap.estimate(tokens[index], destinationPair, amount0);
        }

        return amount1;
    }

    function findDusts(
        address[] memory tokens,
        address wallet
    ) public view returns (address[] memory, uint256[] memory) {
        address[] memory dusts = new address[](tokens.length);
        uint256[] memory amountsInUSDT = new uint256[](tokens.length);

        for (uint index = 0; index < tokens.length; index++) {
            if (tokens[index] == address(0)) continue;

            IERC20 token = IERC20(tokens[index]);
            uint256 amount0 = token.balanceOf(wallet);

            // amount cannot be lesser than 100 WEI
            if (amount0 < 100) continue;

            // skip if token address points to MATIC
            // Native coin (MATIC) is not considered as dust
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
                dusts[index] = tokens[index];
                amountsInUSDT[index] = amount1;
            }
        }

        return (dusts, amountsInUSDT);
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
