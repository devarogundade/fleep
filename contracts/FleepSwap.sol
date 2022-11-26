// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {PriceApi} from "./PriceApi.sol";
import {FleepToken} from "./FleepToken.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FleepSwap {
    PriceApi private _priceApi;
    FleepToken private _fleepToken;

    // contract admin
    address private _deployer;

    // charges 1% fee on every successful swaps
    uint private swapFee = 1;

    // ids to avoid conflicts
    uint256 private POOL_ID;
    uint256 private LIQUID_ID;
    uint256 private PROVIDER_ID;

    // token contract address => chainlink aggregrator address
    // only in the token paired to USD format
    mapping(address => address) public pairs;

    // is a member of the pairs mapping
    // but its the native pair MATIC not ERC20
    address public NATIVE_PAIR;

    // id => liquidity pools
    mapping(uint => Pool) public pools;
    // user address => provider data
    mapping(address => Provider) public providers;
    // id => liquids
    mapping(uint => Liquid) public liquids;

    // === Events === //

    event LiquidityProvided(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        address provider,
        uint timestamp
    );

    event LiquidityRemoved(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        address provider
    );

    event FleepSwaped(
        uint256 amount,
        uint256 amountOut,
        address from,
        address to,
        uint timestamp
    );

    // === Structs === //

    struct Pool {
        uint id;
        address token0;
        address token1;
        uint[] liquids;
    }

    struct Liquid {
        uint id;
        uint poolId;
        uint256 amount0;
        uint256 amount1;
        address provider;
    }

    struct Provider {
        uint id;
        uint256 totalEarned;
        uint256 balance;
        uint[] liquids;
    }

    //  check the price of BNB/SUSHI
    constructor(address priceApI, address fleepToken) {
        _priceApi = PriceApi(priceApI);
        _fleepToken = FleepToken(fleepToken);
        _deployer = msg.sender;
    }

    // calculates all the size of the liquids
    // in a pool of token pair
    function getPoolSize(
        address token0,
        address token1
    ) public view returns (uint256, uint256) {
        uint poolId = _findPool(token0, token1);
        return _poolSize(poolId);
    }

    // gets the exchanges rates for pair of tokens
    // with accordance to amount of tokens
    function estimate(
        address token0,
        address token1,
        uint256 amount0
    ) public view returns (uint256) {
        int256 rate = _priceApi.getExchangeRate(pairs[token0], pairs[token1]);
        return amount0 * uint256(rate);
    }

    // returns the contract address
    function getContractAddress() public view returns (address) {
        return address(this);
    }

    // returns the pair address for $MATIC
    function getNativePair() public view returns (address) {
        return NATIVE_PAIR;
    }

    // register as a provider
    function unlockedProviderAccount() public onlyGuest {
        // to become a provider you must hodl at least 10
        // tokens of Fleep Token
        require(
            _fleepToken.balanceOf(msg.sender) >= _fleepToken.inWei(10),
            "You must hodl at least 10 Fleep Tokens"
        );

        PROVIDER_ID++;
        providers[msg.sender] = Provider(
            PROVIDER_ID,
            providers[msg.sender].totalEarned,
            providers[msg.sender].balance,
            providers[msg.sender].liquids
        );
    }

    // === Swapping === //

    function swap(
        address token0,
        address token1,
        uint256 amount0
    ) public payable returns (uint256) {
        require(amount0 >= 100, "Amount to swap cannot be lesser than 100 WEI");
        require(
            pairs[token0] != address(0),
            "Pair does not exists, Contact admin"
        );
        require(
            pairs[token1] != address(0),
            "Pair does not exists, Contact admin"
        );

        uint256 rate;
        uint256 amount1;

        uint256 _safeAmount0 = amount0;

        uint poolId = _findPool(token0, token1);
        require(pools[poolId].id > 0, "Pool does not exists");

        if (pairs[token0] == NATIVE_PAIR) {
            _safeAmount0 = (msg.value - tx.gasprice);
            rate = uint256(
                _priceApi.getExchangeRate(NATIVE_PAIR, pairs[token1])
            );
            amount1 = _safeAmount0 * uint256(rate);

            ERC20 quoteToken = ERC20(token1);

            (, uint256 poolSizeToken1) = _poolSize(poolId);

            // check if contract has enough destination token liquid
            require(poolSizeToken1 >= amount1, "Insufficient Pool Size");

            uint256 fee = _transferSwappedTokens0(quoteToken, amount1);
            uint256 providersReward = ((fee * 80) / 100);

            _aggregateLiquids(
                amount0,
                amount1,
                poolSizeToken1,
                pools[poolId],
                providersReward
            );
        } else if (pairs[token1] == NATIVE_PAIR) {
            rate = uint256(
                _priceApi.getExchangeRate(pairs[token0], NATIVE_PAIR)
            );
            amount1 = _safeAmount0 * uint256(rate);

            ERC20 baseToken = ERC20(token0);
            baseToken.transferFrom(msg.sender, address(this), _safeAmount0);

            (uint256 poolSizeToken1, ) = _poolSize(poolId);
            require(poolSizeToken1 >= amount1, "Insufficient Pool Size");

            uint256 fee = _transferSwappedTokens1(amount1);
            uint256 providersReward = ((fee * 80) / 100);

            _aggregateLiquids(
                amount0,
                amount1,
                poolSizeToken1,
                pools[poolId],
                providersReward
            );
        } else {
            rate = uint256(
                _priceApi.getExchangeRate(pairs[token0], pairs[token1])
            );
            amount1 = _safeAmount0 * uint256(rate);

            ERC20 baseToken = ERC20(token0);
            ERC20 quoteToken = ERC20(token1);

            (, uint256 poolSizeToken1) = _poolSize(poolId);

            // check if contract has enough destination token liquid
            require(poolSizeToken1 >= amount1, "Insufficient Pool Size");

            uint256 fee = _transferSwappedTokens2(
                baseToken,
                quoteToken,
                amount0,
                amount1,
                msg.sender
            );
            uint256 providersReward = ((fee * 80) / 100);

            _aggregateLiquids(
                amount0,
                amount1,
                poolSizeToken1,
                pools[poolId],
                providersReward
            );
        }

        // store the swap data on-chain
        emit FleepSwaped(amount0, amount1, token0, token1, block.timestamp);

        return amount1;
    }

    // === Providers === //

    function createPool(
        address token0,
        address token1
    ) public onlyProvider returns (uint) {
        // create pool id
        POOL_ID++;
        // create a new pool from struct
        Pool memory pool = pools[POOL_ID];
        // register the pool
        pools[POOL_ID] = Pool(POOL_ID, token0, token1, pool.liquids);
        return POOL_ID;
    }

    function provideLiquidity(
        uint256 amount0,
        uint poolId
    ) public payable onlyProvider returns (uint256, uint256) {
        require(amount0 >= 100, "Amount cannot be lesser than 100 WEI");

        address token0 = pools[poolId].token0;
        address token1 = pools[poolId].token1;

        require(
            pairs[token0] != address(0),
            "Pair does not exists, Contact admin"
        );
        require(
            pairs[token1] != address(0),
            "Pair does not exists, Contact admin"
        );

        uint256 amount1;
        uint256 _safeAmount0 = amount0;

        if (pairs[token0] == NATIVE_PAIR) {
            // only in format of MATIC as pair subject
            // ex MATIC/XEND
            _safeAmount0 = msg.value;

            amount1 = estimate(pairs[token0], pairs[token1], _safeAmount0);

            // stake token0 to smart contract
            ERC20 quoteToken = ERC20(token1);
            quoteToken.transferFrom(msg.sender, address(this), amount0);
        } else {
            amount1 = estimate(pairs[token0], pairs[token1], _safeAmount0);

            // stake token0 to smart contract
            ERC20 baseToken = ERC20(token0);
            baseToken.transferFrom(msg.sender, address(this), _safeAmount0);
            // stake token1 to smart contract
            ERC20 quoteToken = ERC20(token1);
            quoteToken.transferFrom(msg.sender, address(this), amount1);
        }

        (bool hasLiquid, uint liquidId) = _liquidIndex(poolId, msg.sender);

        if (hasLiquid) {
            // if liquid exist increment the amount
            liquids[liquidId].amount0 += _safeAmount0;
            liquids[liquidId].amount1 += amount1;
        } else {
            _createLiquid(poolId, _safeAmount0, amount1, msg.sender);
        }

        // store the liquidity data on-chain
        emit LiquidityProvided(
            token0,
            token1,
            _safeAmount0,
            amount1,
            msg.sender,
            block.timestamp
        );

        return (_safeAmount0, amount1);
    }

    function removeLiquidity(uint id) public onlyProvider {
        require(liquids[id].provider == msg.sender, "Unauthorized");

        Pool memory pool = pools[liquids[id].poolId];
        ERC20 token0 = ERC20(pool.token0);
        ERC20 token1 = ERC20(pool.token1);

        token0.transfer(msg.sender, liquids[id].amount0);
        token1.transfer(msg.sender, liquids[id].amount1);

        emit LiquidityRemoved(
            address(token0),
            address(token1),
            liquids[id].amount0,
            liquids[id].amount1,
            msg.sender
        );

        // delete liquid TO DO
        liquids[id].amount0 = 0;
        liquids[id].amount1 = 0;
    }

    function withDrawEarnings(uint256 amount) public onlyProvider {
        require(
            providers[msg.sender].balance >= amount,
            "Insufficient Balance"
        );
        providers[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    // === Administration === //

    function updateNativePair(address pair) public onlyDeployer {
        require(pair != address(0), "Invalid Pair Address");
        NATIVE_PAIR = pair;
    }

    function updateSwapFee(uint fee) public onlyDeployer {
        require(fee > 0, "Platform fee cannot be zero");
        require(fee < 100, "Platform fee cannot be a hundred");
        swapFee = fee;
    }

    function createPair(address token, address pair) public onlyDeployer {
        require(token != address(0), "Invalid Token Address");
        require(pair != address(0), "Invalid Pair Address");
        pairs[token] = pair;
    }

    // === Internal Functions === //

    function _liquidIndex(
        uint poolId,
        address provider
    ) private view returns (bool, uint) {
        uint256[] memory providerLiquids = providers[provider].liquids;

        for (uint index = 0; index < providerLiquids.length; index++) {
            if (liquids[providerLiquids[index]].poolId == poolId) {
                return (true, liquids[providerLiquids[index]].id);
            }
        }

        return (false, 0);
    }

    function _aggregateLiquids(
        uint256 amount0,
        uint256 amount1,
        uint256 poolSizeToken1,
        Pool memory pool,
        uint256 fee
    ) private {
        // equally share swap impact on all provider liquids based on their contribution
        for (uint index = 0; index < pool.liquids.length; index++) {
            uint liquidId = pool.liquids[index];

            // calculated with ratio of this liquid compared
            // to other liquids contributing
            uint256 additionAmount = ((liquids[liquidId].amount1 * amount0) /
                poolSizeToken1);

            // step I
            liquids[liquidId].amount0 += additionAmount;

            // calculated with ratio of this liquid compared
            // to other liquids contributing
            uint256 deductionAmount = ((liquids[liquidId].amount1 * amount1) /
                poolSizeToken1);

            // step II
            liquids[liquidId].amount1 -= deductionAmount;

            // reward the liquid provider
            uint256 reward = ((liquids[liquidId].amount1 * fee) /
                poolSizeToken1);

            providers[liquids[liquidId].provider].totalEarned += reward;
            providers[liquids[liquidId].provider].balance += reward;
        }
    }

    function _transferSwappedTokens0(
        ERC20 token1,
        uint256 amount1
    ) private returns (uint256) {
        uint256 _fee = ((amount1 / 100) * swapFee);

        // give user their destination token minus fee
        token1.transfer(msg.sender, (amount1 - _fee));

        // convert fee to matic
        return estimate(address(token1), NATIVE_PAIR, _fee);
    }

    function _transferSwappedTokens1(
        uint256 amount1
    ) public payable returns (uint256) {
        uint256 _fee = ((amount1 / 100) * swapFee);

        // give user their destination token minus fee
        payable(msg.sender).transfer(amount1 - _fee);
        return _fee;
    }

    function _transferSwappedTokens2(
        ERC20 token0,
        ERC20 token1,
        uint256 amount0,
        uint256 amount1,
        address owner
    ) private returns (uint256) {
        uint256 _fee = ((amount1 / 100) * swapFee);

        // tranfers the base token from user to the
        // smart contract
        token0.transferFrom(owner, address(this), amount0);

        // give user their destination token minus fee
        token1.transfer(owner, (amount1 - _fee));

        // convert fee to matic
        return estimate(address(token1), NATIVE_PAIR, _fee);
    }

    function _findPool(
        address token0,
        address token1
    ) private view returns (uint) {
        require(token0 != address(0) && token1 != address(0), "Invalid");
        for (uint index = 0; index <= POOL_ID; index++) {
            if (
                pools[index].token0 == token0 && pools[index].token1 == token1
            ) {
                return index;
            }

            if (
                pools[index].token0 == token1 && pools[index].token1 == token0
            ) {
                return index;
            }
        }
        return 0;
    }

    function _createLiquid(
        uint poolId,
        uint256 amount0,
        uint256 amount1,
        address provider
    ) private onlyProvider {
        // otherwise create the new liquid
        LIQUID_ID++;
        // create the liquid
        liquids[LIQUID_ID] = Liquid(
            LIQUID_ID,
            poolId,
            amount0,
            amount1,
            provider
        );
        // register the liquid
        pools[poolId].liquids.push(LIQUID_ID);
        providers[provider].liquids.push(LIQUID_ID);
    }

    function _poolSize(uint id) private view returns (uint256, uint256) {
        uint256 amount0;
        uint256 amount1;
        for (uint index = 0; index < pools[id].liquids.length; index++) {
            uint liquidId = pools[id].liquids[index];
            amount0 += liquids[liquidId].amount0;
            amount1 += liquids[liquidId].amount1;
        }
        return (amount0, amount1);
    }

    // === Modifiers === //

    modifier onlyGuest() {
        require(providers[msg.sender].id == 0, "Only Guest");
        _;
    }

    modifier onlyProvider() {
        require(providers[msg.sender].id != 0, "Only Provider");
        _;
    }

    modifier onlyDeployer() {
        require(msg.sender == _deployer, "Only Deployer");
        _;
    }
}
