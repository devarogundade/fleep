<template>
<div class="picker">
    <div class="head">
        <i class="fi fi-rr-cross" v-on:click="$emit('close')"></i>
        <h3>Order history</h3>
    </div>
    <div class="body">
        <div class="tokens">
            <div class="token" v-for="token in tokens" :key="token.symbol">
                <div class="left">
                    <img :src="token.image" alt="">
                    <p>{{ token.name }}</p>
                </div>
                <div class="right">
                    <p>0x4d...83d2</p>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import testnetTokens from "../../static/tokens/testnet.json"
import mainnetTokens from "../../static/tokens/mainnet.json"
import Network from "../../static/scripts/Network"

export default {
    data() {
        return {
            tokens: [],
            network: Network.current() == 'true'
        }
    },
    mounted() {
        if (this.network) {
            // mainnet
            this.tokens = mainnetTokens
        } else {
            // testnet
            this.tokens = testnetTokens
        }
    }
}
</script>

<style scoped>
.picker {
    position: fixed;
    right: 0;
    width: 400px;
    max-width: 100%;
    height: 100vh;
    top: 0;
    box-shadow: 0 0 10px #CCC;
    z-index: 10;
    background: #fff;
}

.head {
    height: 60px;
    border-bottom: 1px solid #ccc;
    display: flex;
    align-items: center;
    padding: 20px;
    gap: 20px;
}

.head h3 {
    font-family: 'neue';
}

.head i {
    font-size: 16px;
    cursor: pointer;
}

.token .left {
    display: flex;
    align-items: center;
    gap: 10px;
}

.token img {
    height: 24px;
    border-radius: 20px;
}

.token .left p {
    font-size: 16px;
    margin-top: -4px;
}

.token {
    padding: 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 55px;
    cursor: pointer;
    user-select: none;
}

.token:hover {
    background: #FAFAFA;
}

.token .right p {
    font-size: 14px;
    text-decoration: underline;
}
</style>
