<template>
<section>
    <div class="app-width">
        <div class="params">
            <p>Last Response: {{ response }}</p>
        </div>

        <div class="pairs">
            <button v-on:click="testnetHelper2()">Testnet Helper 2</button>
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
            response: '',
            network: Network.current() == 'true'
        }
    },
    methods: {
        testnetHelper2: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address
            this.response = await FleepSwap.testnetHelper2(address)
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
