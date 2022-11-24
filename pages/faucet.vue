<template>
<section>
    <div class="app-width">
        <div class="faucet">
            <div class="tokens">
                <div class="token" v-for="token in tokens" :key="token.symbol">
                    <img :src="token.image" alt="">
                    <p>{{ token.name }} ({{ token.symbol }})</p>
                    <p>{{ 1000 }}</p>
                    <button v-on:click="faucetMint(token)">Mint</button>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import testnetTokens from "../static/tokens/testnet.json"
import contractJson from "../build/contracts/TestnetToken.json"
import Web3 from "web3"
import Authenticate from '~/static/scripts/Authenticate';
import Utils from '~/static/scripts/Utils';

export default {
    layout: 'landing',
    data() {
        return {
            minting: -1,
            tokens: testnetTokens
        };
    },
    mounted() {
        console.log(contractJson.abi);
    },
    methods: {
        faucetMint: async function (token) {
            if (this.minting != -1) return
            const address = (await Authenticate.getUserAddress(false)).address

            const web3 = new Web3(ethereum)
            const contract = new web3.eth.Contract(contractJson.abi, token.address)

            const gasPrice = await contract.methods.faucet(address, 1).estimateGas({from: token.address})

            contract.methods.faucet(address, 1).send({
                from: address,
                gasPrice: gasPrice
            })

            this.minting = -1
        },
    },
};
</script>

<style scoped>
section {
    padding: 150px 0;
}

.container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    padding: 200px 0;
}

.form {
    width: 450px;
    border-radius: 30px;
    padding: 40px;
    box-shadow: 0 6px 10px #ccc;
    height: fit-content;
}

.input {
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    box-shadow: 0 4px 8px #ccc;
    border-radius: 10px;
    padding: 10px;
    margin-bottom: 20px;
}

.input input {
    width: 100%;
    background: transparent;
    font-size: 20px;
    font-weight: 600;
    padding-right: 20px;
    height: 100%;
    border: none;
    outline: none;
}

.input .token {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
    cursor: pointer;
    user-select: none;
}

.token img {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    object-fit: cover;
}

.price {
    margin: 30px 0;
    text-align: center;
    font-size: 18px;
}

.action {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    background: #1900b3;
    font-size: 16px;
    cursor: pointer;
    user-select: none;
    font-weight: 600;
    color: #ff9d05;
}
</style>
