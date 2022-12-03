<template>
<section>
    <div class="app-width">
        <div class="swap">
            <div class="head">
                <div class="toolbar">
                    <input type="text" placeholder="Search by name or address">
                    <router-link :to="localePath('/dapp/earnings')">
                        <div class="my-liquid">My Liquidities</div>
                    </router-link>
                </div>
            </div>
            <div class="liquidities">
                <div class="liquidity">
                    <div class="images">
                        <img>
                        <img>
                    </div>
                    <p class="name">Pair</p>
                    <p class="available">Available Pool Size</p>
                    <p class="action"></p>
                </div>
                <div class="liquidity" v-for="(pool, index) in pools" :key="index">
                    <div class="images">
                        <img :src="poolToken(pool.token0).image" alt="">
                        <img :src="poolToken(pool.token1).image" alt="">
                    </div>
                    <p class="name">{{ `${poolToken(pool.token0).name} (${poolToken(pool.token0).symbol}) / ${poolToken(pool.token1).name} (${poolToken(pool.token1).symbol})` }}</p>
                    <p class="available" v-if="pool.amount0 && pool.amount1">{{ pool.amount0 }} {{ poolToken(pool.token0).symbol }} / {{ pool.amount1 }} {{ poolToken(pool.token1).symbol }}</p>
                    <p class="available" v-else>••• {{ poolToken(pool.token0).symbol }} / ••• {{ poolToken(pool.token1).symbol }}</p>
                    <div class="action">
                        <router-link :to="`/dapp/liquidity/${pool.id}`">
                            <div class="add-liquid">Add Liquidity</div>
                        </router-link>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import testnetTokens from "../../static/tokens/testnet.json"
import mainnetTokens from "../../static/tokens/mainnet.json"
import mainnetPools from "../../static/pools/mainnet.json"
import testnetPools from "../../static/pools/testnet.json"
import Network from "../../static/scripts/Network"
import FleepSwap from '~/static/scripts/FleepSwap'
import Utils from '~/static/scripts/Utils'

export default {
    data() {
        return {
            tokens: [],
            pools: [],
            network: Network.current() == 'true'
        }
    },
    mounted() {
        if (this.network) {
            // mainnet
            this.tokens = mainnetTokens
            this.pools = mainnetPools
        } else {
            // testnet
            this.tokens = testnetTokens
            this.pools = testnetPools
        }

        this.findPools()
    },
    methods: {
        poolToken: function (address) {
            return this.tokens.filter(token => token.address == address)[0]
        },
        findPools: async function () {
            for (let index = 0; index < this.pools.length; index++) {
                const pool = this.pools[index];
                const response = await FleepSwap.getPoolSize(pool.token0, pool.token1)
                if (response) {
                    pool.amount0 = Utils.toMoney(Utils.fromWei(response[0]))
                    pool.amount1 = Utils.toMoney(Utils.fromWei(response[1]))
                }
            }
        }
    }
}
</script>

<style scoped>
section {
    background: #fff;
    background-image: url('/images/liquid.svg');
    background-size: cover;
}

.swap {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex-wrap: wrap;
    width: 100%;
    padding: 150px 0;
    min-height: 95vh;
}

.head {
    width: 100%;
    max-width: 800px;
    margin-bottom: 20px;
}

.liquidities {
    width: 800px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.liquidity {
    width: 100%;
    border-radius: 16px;
    background: #eef1f5;
    height: 65px;
    display: flex;
    padding: 0 20px;
    align-items: center;
    gap: 16px;
    cursor: pointer;
}

.liquidity:hover {
    background: #e7e7e7;
}

.liquidity:first-child {
    height: 40px;
    background: transparent;
}

.liquidity:first-child p {
    font-family: 'neue';
}

.liquidity .images {
    display: flex;
    align-items: center;
}

.liquidity img {
    height: 30px;
    width: 30px;
    object-fit: cover;
    border-radius: 20px;
}

.liquidity img:nth-child(2) {
    margin-left: -12px;
}

.liquidity .name {
    margin-top: -4px;
    font-size: 16px;
    width: 400px;
}

.liquidity .available {
    margin-top: -4px;
    font-size: 16px;
    width: 400px;
    text-align: right;
}

.liquidity .action {
    margin-top: -4px;
    font-size: 16px;
    width: 300px;
    display: flex;
    justify-content: flex-end;
}

.toolbar {
    margin-top: 10px;
    display: flex;
    align-items: center;
    width: 100%;
    height: 50px;
    gap: 20px;
}

.toolbar input {
    height: 100%;
    border-radius: 16px;
    background: #f5f5f5;
    border: none;
    outline: none;
    padding: 0 20px;
    border: 1px #ccc solid;
    font-size: 16px;
    width: 100%;
}

.my-liquid {
    width: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #000986;
    height: 50px;
    border-radius: 20px;
    color: #fff;
}

.add-liquid {
    width: 140px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #cacfff;
    height: 40px;
    border-radius: 10px;
    color: #000986;
    font-size: 14px;
}
</style>
