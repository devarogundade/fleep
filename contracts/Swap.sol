// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {PriceApi} from "./PriceApi.sol";
import {Token} from "./Token.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swap {
    PriceApi private _priceApi;
    Token private _token;

    // contract admin
    address private _deployer;
    uint256 private _platformProfit;

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
    // but its the native pair MATIC not IERC20
    address public NATIVE_PAIR = 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada;

    // id => liquidity pools
    mapping(uint => Pool) public pools;
    // user address => provider data
    mapping(address => Provider) public providers;
    // id => liquids
    mapping(uint => Liquid) public liquids;

    // === Events === //

    event LiquidProvided(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        address provider,
        uint timestamp
    );

    event LiquidRemoved(
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
        address vaultAddress;
        bool autoStake;
        uint[] liquids;
    }

    constructor(address priceApI, address token) {
        _priceApi = PriceApi(priceApI);
        _token = Token(token);
        _deployer = msg.sender;

        createPair(
            0xc0EC2DCA88Dbe3C91518958C935Ce250c718f0EB,
            0x007A22900a3B98143368Bd5906f8E17e9867581b
        );
        createPair(
            0x3814CF88e2675041504C7d6404f7b8978F8B65B4,
            0x0FCAa9c899EC5A91eBc3D5Dd869De833b06fB046
        );
        createPair(NATIVE_PAIR, NATIVE_PAIR);
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
        uint256 amount0 // in wei
    ) public view returns (uint256) {
        int256 rate = _priceApi.getExchangeRate(pairs[token0], pairs[token1]);
        return (amount0 * uint256(rate)) / (10 ** 8);
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
    function unlockedProviderAccount(address _vaultAddress) public onlyGuest {
        // to become a provider you must hodl at least 10
        // tokens of Fleep Token
        require(
            _token.balanceOf(msg.sender) >= _token.inWei(10),
            "You must hodl at least 10 Fleep Tokens"
        );

        PROVIDER_ID++;
        providers[msg.sender] = Provider(
            PROVIDER_ID,
            providers[msg.sender].totalEarned,
            providers[msg.sender].balance,
            _vaultAddress,
            false,
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

        uint256 amount1;
        uint256 _safeAmount0 = amount0;

        uint poolId = _findPool(token0, token1);
        require(pools[poolId].id > 0, "Pool does not exists");

        // MATIC => ERC20
        if (pools[poolId].token0 == NATIVE_PAIR) {
            _safeAmount0 = msg.value;
            amount1 = estimate(NATIVE_PAIR, pools[poolId].token1, _safeAmount0);

            // check if contract has enough destination token liquid
            (, uint256 poolSizeToken1) = _poolSize(poolId);
            require(poolSizeToken1 >= amount1, "Insufficient Pool Size");

            uint256 fee = _transferSwappedTokens0(
                pools[poolId].token1,
                amount1,
                msg.sender
            );

            uint256 providersReward = ((fee * 80) / 100);
            _platformProfit += (fee - providerReward);

            _aggregateLiquids(
                _safeAmount0,
                amount1,
                poolSizeToken1,
                pools[poolId],
                providersReward
            );
        } else if (pools[poolId].token1 == NATIVE_PAIR) {
            // ERC20 => MATIC
            amount1 = estimate(pools[poolId].token0, NATIVE_PAIR, _safeAmount0);

            // check if contract has enough destination token liquid
            (uint256 poolSizeToken1, ) = _poolSize(poolId);
            require(poolSizeToken1 >= amount1, "Insufficient Pool Size");

            uint256 fee = _transferSwappedTokens1(
                pools[poolId].token0,
                _safeAmount0,
                amount1,
                msg.sender
            );

            uint256 providersReward = ((fee * 80) / 100);
            _platformProfit += (fee - providerReward);

            _aggregateLiquids(
                _safeAmount0,
                amount1,
                poolSizeToken1,
                pools[poolId],
                providersReward
            );
        } else {
            // ERC0 => ERC2O
            amount1 = estimate(
                pools[poolId].token0,
                pools[poolId].token1,
                _safeAmount0
            );

            // check if contract has enough destination token liquid
            (, uint256 poolSizeToken1) = _poolSize(poolId);
            require(poolSizeToken1 >= amount1, "Insufficient Pool Size");

            uint256 fee = _transferSwappedTokens2(
                pools[poolId].token0,
                pools[poolId].token1,
                _safeAmount0,
                amount1,
                msg.sender
            );

            uint256 providersReward = ((fee * 80) / 100);
            _platformProfit += (fee - providerReward);

            _aggregateLiquids(
                _safeAmount0,
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

    function provideLiquidity(
        uint poolId,
        uint256 amount0
    ) public payable onlyProvider {
        require(amount0 >= 100, "Amount cannot be lesser than 100 WEI");

        uint256 amount1;
        uint256 _safeAmount0 = amount0;

        if (pools[poolId].token0 == NATIVE_PAIR) {
            require(msg.value > 100, "Matic cannot be lesser than 1OO WEI");
            // only in format of MATIC as pair subject
            // ex MATIC/XEND

            _safeAmount0 = msg.value;
            // get the estimate for token1
            amount1 = estimate(
                pools[poolId].token0,
                pools[poolId].token1,
                _safeAmount0
            );
            // stake token1 to smart contract
            IERC20(pools[poolId].token1).transferFrom(
                msg.sender,
                address(this),
                amount1
            );
        } else {
            // get the estimate for token1
            amount1 = estimate(
                pools[poolId].token0,
                pools[poolId].token1,
                _safeAmount0
            );
            // stake tokens to smart contract
            IERC20(pools[poolId].token0).transferFrom(
                msg.sender,
                address(this),
                _safeAmount0
            );
            IERC20(pools[poolId].token1).transferFrom(
                msg.sender,
                address(this),
                amount1
            );
        }

        uint liquidId = _liquidIndex(poolId, msg.sender);

        if (liquidId > 0) {
            // if liquid exist increment the amount
            liquids[liquidId].amount0 += _safeAmount0;
            liquids[liquidId].amount1 += amount1;
        } else {
            // otherwise create the new liquid
            _createLiquid(poolId, _safeAmount0, amount1, msg.sender);
        }

        // store the liquidity data on-chain
        emit LiquidProvided(
            pools[poolId].token0,
            pools[poolId].token1,
            _safeAmount0,
            amount1,
            msg.sender,
            block.timestamp
        );
    }

    function removeLiquidity(uint id) public onlyProvider {
        require(liquids[id].provider == msg.sender, "Unauthorized");

        Pool memory pool = pools[liquids[id].poolId];
        IERC20 token0 = IERC20(pool.token0);
        IERC20 token1 = IERC20(pool.token1);

        token0.transfer(msg.sender, liquids[id].amount0);
        token1.transfer(msg.sender, liquids[id].amount1);

        emit LiquidRemoved(
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

    function createPool(
        address token0,
        address token1
    ) public onlyProvider returns (uint) {
        return _createPool(token0, token1);
    }

    function updateProviderProfile(bool _autoStake) public onlyProvider {
        providers[msg.sender].autoStake = _autoStake;
    }

    function withDrawEarnings(uint256 amount) public onlyProvider {
        require(
            providers[msg.sender].balance >= amount,
            "Insufficient Balance"
        );
        payable(msg.sender).transfer(amount);
        providers[msg.sender].balance -= amount;
    }

    function withDrawEarningsToVault(address receiver) public onlyProvider {
        uint256 amount = providers[msg.sender].balance;
        require(amount >= _token.inWei(1), "Balance Must be atleast 1 MATIC");
        payable(receiver).transfer(amount);
        providers[msg.sender].balance = 0;
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
    ) private view returns (uint) {
        uint256[] memory providerLiquids = providers[provider].liquids;

        for (uint index = 0; index < providerLiquids.length; index++) {
            if (liquids[providerLiquids[index]].poolId == poolId) {
                return providerLiquids[index];
            }
        }

        return 0;
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

            address provider = liquids[liquidId].provider;

            providers[provider].totalEarned += reward;
            providers[provider].balance += reward;

            // if provider is auto staking rewards in XEND vault
            // and their balance is at least 1 MATIC
            if (
                providers[provider].autoStake &&
                providers[provider].balance >= _token.inWei(1)
            ) {
                payable(providers[provider].vaultAddress).transfer(
                    providers[provider].balance
                );
                providers[provider].balance = 0;
            }
        }
    }

    // MATIC => ERC20
    function _transferSwappedTokens0(
        address token1,
        uint256 amount1,
        address owner
    ) private returns (uint256) {
        IERC20 quoteToken = IERC20(token1);

        uint256 _fee = ((amount1 / 100) * swapFee);

        // give user their destination token minus fee
        quoteToken.transfer(owner, (amount1 - _fee));

        // convert fee to matic
        return estimate(token1, NATIVE_PAIR, _fee);
    }

    // ERC20 => MATIC
    function _transferSwappedTokens1(
        address token0,
        uint256 amount0,
        uint256 amount1,
        address owner
    ) public payable returns (uint256) {
        IERC20 baseToken = IERC20(token0);

        uint256 _fee = ((amount1 / 100) * swapFee);

        baseToken.transferFrom(owner, address(this), amount0);

        // give user their destination token minus fee
        payable(owner).transfer(amount1 - _fee);

        // fee already in matic
        return _fee;
    }

    // ERC20 => ERC20
    function _transferSwappedTokens2(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        address owner
    ) private returns (uint256) {
        IERC20 baseToken = IERC20(token0);
        IERC20 quoteToken = IERC20(token1);

        uint256 _fee = ((amount1 / 100) * swapFee);

        // tranfers the base token from user to the
        // smart contract
        baseToken.transferFrom(owner, address(this), amount0);

        // give user their destination token minus fee
        quoteToken.transfer(owner, (amount1 - _fee));

        // convert fee to matic
        return estimate(token1, NATIVE_PAIR, _fee);
    }

    function _findPool(
        address token0,
        address token1
    ) private view returns (uint) {
        require(
            token0 != address(0) && token1 != address(0),
            "Invalid Pool Tokens"
        );
        for (uint index = 0; index <= POOL_ID; index++) {
            // patern A
            if (
                pools[index].token0 == token0 && pools[index].token1 == token1
            ) {
                return index;
            }

            // pattern B
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
    ) private {
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

    function _createPool(
        address token0,
        address token1
    ) private returns (uint) {
        require(
            pairs[token0] != address(0),
            "Pair does not exists, Contact admin"
        );
        require(
            pairs[token1] != address(0),
            "Pair does not exists, Contact admin"
        );

        bool exists = _findPool(token0, token1) != 0;
        if (exists) return 0;

        POOL_ID++;
        Pool memory pool = pools[POOL_ID];

        pools[POOL_ID] = Pool(POOL_ID, token0, token1, pool.liquids);

        return POOL_ID;
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
