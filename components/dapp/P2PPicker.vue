<template>
<div class="picker">
    <div class="head">
        <i class="fi fi-rr-cross" v-on:click="$emit('close')"></i>
        <h3>Select a currency</h3>
    </div>
    <div class="body">
        <div class="tokens">
            <div class="token" v-for="currency in currencies" :key="currency.symbol" v-on:click="$emit('pick', currency)">
                <div class="left">
                    <img :src="currency.image" alt="">
                    <p>{{ currency.name }}</p>
                </div>
                <div class="right">
                    <p>{{ currency.symbol }}</p>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import tokens from "../../static/p2p/tokens.json"
import currencies from "../../static/p2p/currencies.json"
import Network from "../../static/scripts/Network"

export default {
    props: ['type'],
    data() {
        return {
            currencies: this.type == 'currency' ? currencies : tokens,
            network: Network.current() == 'true'
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
    width: 24px;
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
