<template>
<section>
    <div class="app-width">
        <div class="params">
            <p>Token0: {{ token0 }}</p>
            <p>Token1: {{ token1 }}</p>
            <p>Last Response: {{ response }}</p>
        </div>

        <div class="create_pair">
            <input type="Token Address" v-model="token0">
            <input type="Pair Address" v-model="token1">
            <button v-on:click="createPair()">Create Pair</button>
        </div>

        <div class="create_pool">
            <input type="Token 0" v-model="token0">
            <input type="Token 1" v-model="token1">
            <button v-on:click="createPool()">Create Pool</button>
        </div>

        <div class="update_native_pair">
            <input type="Pair Address" v-model="token0">
            <button v-on:click="updateNativePair()">Update Native Pair</button>
        </div>

        <div class="pairs">
            <button v-on:click="getPairs()">Pairs</button>
        </div>
    </div>
</section>
</template>

<script>
import Authenticate from '~/static/scripts/Authenticate'
import FleepSwap from '~/static/scripts/FleepSwap'
import FleepVault from '~/static/scripts/FleepVault'
import Network from '~/static/scripts/Network'

export default {
    layout: 'dapp',
    data() {
        return {
            token0: '',
            token1: '',
            response: '',
            network: Network.current() == 'true'
        }
    },
    methods: {
        createPair: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address
            this.response = await FleepSwap.createPair(this.token0, this.token1, address)
        },
        createPool: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address
            this.response = await FleepSwap.createPool(this.token0, this.token1, address)
        },
        updateNativePair: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address
            this.response = await FleepSwap.updateNativePair(this.token0, address)
        },
        getPairs: async function () {
            await FleepSwap.pairs()
        }
    }
}
</script>

<style scoped>
.app-width {
    padding: 100px;
}

div {
    padding: 20px;
}
</style>
