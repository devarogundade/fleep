<template>
<section>
    <div class="app-width">
        <div class="faucet">
            <div class="tokens">
                <div class="token" v-for="token in tokens" :key="token.symbol">
                    <img :src="token.image" alt="">
                    <p>{{ token.name }} ({{ token.symbol }})</p>
                    <p>100</p>
                    <p>{{ token.address }}</p>
                    <button v-on:click="faucetMint(token)">Mint</button>
                    <button v-on:click="addToMetamask(token)">Add to Metamask</button>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import Web3 from "web3"
import testnetTokens from "../static/tokens/testnet.json"
import contractJson from "../build/testnet/TestnetToken.json"
import Authenticate from '~/static/scripts/Authenticate';
import Utils from '~/static/scripts/Utils';
import ERC20 from '~/static/scripts/ERC20';

export default {
    layout: 'landing',
    data() {
        return {
            minting: -1,
            tokens: testnetTokens.filter(t => t.address != '0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada')
        };
    },
    methods: {
        faucetMint: async function (token) {
            if (this.minting != -1) return
            const address = (await Authenticate.getUserAddress(false)).address

            const web3 = new Web3(ethereum)
            const contract = new web3.eth.Contract(contractJson.abi, token.address)

            // const gasPrice = await contract.methods.faucet(address, 1).estimateGas({from: token.address})

            contract.methods.faucet(Utils.toWei('100')).send({
                from: address
            })

            this.minting = -1
        },
        addToMetamask: async function (token) {
            await ERC20.addToWallet(token)
        }
    },
};
</script>

<style scoped>
section {
    padding: 150px 0;
    min-height: 95vh;
}

.token {
    width: 100%;
    height: 100%;
    gap: 20px;
}

.token {
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
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

button {
    padding: 4px 10px;
    cursor: pointer;
}
</style>
