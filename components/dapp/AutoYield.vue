<template>
<section>
    <div class="app-width">
        <div class="swap">
            <div class="head">
                <div class="toolbar">
                    <input type="text" placeholder="Search by asset">
                </div>
            </div>
            <div class="yields">
                <div class="yield">
                    <div class="images">
                        <img>
                    </div>
                    <p class="name">Asset</p>
                    <p class="name2">APY</p>
                    <p class="name2">Locked</p>
                    <p class="name2">Balance</p>
                    <p class="action"></p>
                </div>
                <div class="yield" v-for="(_yield, index) in yields" :key="index">
                    <div class="images">
                        <img :src="yieldToken(_yield.address).image" alt="">
                    </div>
                    <p class="name">{{ `${yieldToken(_yield.address).name} (${yieldToken(_yield.address).symbol})` }}</p>
                    <p class="name2">{{ _yield.apy }}</p>
                    <p class="name2">{{ _yield.locked }}</p>
                    <p class="name2">{{ _yield.vaultBalance }}</p>
                    <div class="action">
                        <div class="deposit">Deposit</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import tokens from "../../static/tokens/mainnet.json"
import yields from "../../static/vault/yields.json"
import FleepVault from '~/static/scripts/FleepVault'
import Utils from '~/static/scripts/Utils'

export default {
    data() {
        return {
            tokens: tokens,
            yields: yields
        }
    },
    methods: {
        yieldToken: function (address) {
            return this.tokens.filter(token => token.address == address)[0]
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

.yields {
    width: 800px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.yield {
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

.yield:hover {
    background: #e7e7e7;
}

.yield:first-child {
    height: 40px;
    background: transparent;
}

.yield:first-child p {
    font-family: 'neue';
}

.yield img {
    height: 30px;
    width: 30px;
    object-fit: cover;
    border-radius: 20px;
}

.yield .name {
    margin-top: -8px;
    font-size: 16px;
    width: 400px;
}

.yield .name2 {
    margin-top: -8px;
    font-size: 16px;
    width: 250px;
}

.yield .action {
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

.deposit {
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
