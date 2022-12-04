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
                        <div class="deposit" v-on:click="to.token = _yield">Deposit</div>
                    </div>
                    <div class="action">
                        <div class="deposit" v-on:click="from.token = _yield">Withdraw</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="blog" v-on:click="blog = true">
            <p>How to AutoYield?</p>
        </div>
    </div>

    <div class="pop" v-if="to.token">
        <h3>Enter Amount <i v-on:click="closePop()" class="fi fi-rr-cross"></i></h3>
        <div class="input">
            <div class="token">
                <div class="lt">
                    <img :src="yieldToken(to.token.address).image" alt="" />
                    <p class="symbol">{{ yieldToken(to.token.address).symbol }}</p>
                </div>
            </div>
            <input v-model="to.amount" type="number" min="0" placeholder="0" />
        </div>
        <div class="button">
            <div v-if="!depositing">
                <div class="action" v-on:click="deposit(to.token)">Deposit</div>
            </div>
            <div class="action" v-else>
                <TinyProgress />
            </div>

            <p>Enter amount.</p>
        </div>
    </div>

    <div class="pop" v-if="from.token">
        <h3>Enter Amount <i v-on:click="closePop()" class="fi fi-rr-cross"></i></h3>
        <div class="input">
            <div class="token">
                <div class="lt">
                    <img :src="yieldToken(from.token.address).image" alt="" />
                    <p class="symbol">{{ yieldToken(from.token.address).symbol }}</p>
                </div>
            </div>
            <input v-model="from.amount" type="number" min="0" placeholder="0" />
        </div>
        <div class="button">
            <div v-if="!withdrawing">
                <div class="action" v-on:click="withdraw(from.token)">Withdraw</div>
            </div>
            <div class="action" v-else>
                <TinyProgress />
            </div>

            <p>Enter amount.</p>
        </div>
    </div>

    <Blog v-if="blog" v-on:close="blog = false" />
</section>
</template>

<script>
import tokens from "../../static/tokens/mainnet.json"
import yields from "../../static/vault/yields.json"
import FleepVault from '~/static/scripts/FleepVault'
import Network from '~/static/scripts/Network'
import Authenticate from '~/static/scripts/Authenticate'
import Utils from '~/static/scripts/Utils'

export default {
    data() {
        return {
            tokens: tokens,
            yields: yields,
            network: Network.current() == 'true',
            blog: false,
            depositing: false,
            withdrawing: false,
            to: {
                amount: "",
                token: null
            },
            from: {
                amount: "",
                token: null
            }
        }
    },
    mounted() {
        this.loadValues()
    },
    methods: {
        loadValues: async function () {
            for (let index = 0; index < this.yields.length; index++) {
                this.yields[index].locked = Utils.toMoney(await this.locked(this.yields[index]))
                this.yields[index].vaultBalance = Utils.toMoney(await this.balance(this.yields[index]))
            }
        },
        yieldToken: function (address) {
            return this.tokens.filter(token => token.address == address)[0]
        },
        closePop: function () {
            this.to.token = null
            this.to.amount = ""
            this.from.token = null
            this.from.amount = ""
        },
        deposit: async function (_yield) {
            if (this.to.token == null || this.to.amount == '') return
            const address = (await Authenticate.getUserAddress(this.network)).address

            if (!this.network) {
                alert('Switch to mainnet')
                return
            }

            this.depositing = true
            const approve = await FleepVault.approve(
                Utils.toWei(this.to.amount),
                address,
                _yield.address,
                _yield.contractAddress
            )

            if (!approve) {
                this.depositing = false
                return
            }

            const response = await FleepVault.deposit(
                1,
                address,
                _yield.contractAddress
            )
            this.depositing = false
        },
        withdraw: async function (_yield) {
            if (this.from.token == null || this.from.amount == '') return
            const address = (await Authenticate.getUserAddress(this.network)).address

            this.withdrawing = true

            const response = await FleepVault.withdraw(
                Utils.toWei(this.from.amount),
                address,
                _yield.address
            )

            this.withdrawing = false
        },
        locked: async function (token) {
            const address = (await Authenticate.getUserAddress(this.network)).address
            return Utils.fromWei(await FleepVault.balance(address, token.address))
        },
        balance: async function (token) {
            const address = (await Authenticate.getUserAddress(this.network)).address
            return Utils.fromWei(await FleepVault.savings(address, token.address))
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

.app-width {
    min-height: 95vh;
    padding: 150px 0;
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
}

.swap {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex-wrap: wrap;
    width: 100%;
}

.blog {
    height: 45px;
    display: flex;
    align-items: center;
    border-radius: 10px;
    background: rgb(250, 228, 253);
    border: 1px rgb(253, 192, 192) solid;
    overflow: hidden;
    user-select: none;
    cursor: pointer;
}

.blog p {
    padding: 0 20px;
    font-size: 16px;
    font-weight: 600;
}

.blog img {
    width: 50px;
    height: 100%;
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
    width: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #cacfff;
    height: 40px;
    border-radius: 10px;
    color: #000986;
    font-size: 14px;
}

.pop {
    width: 300px;
    border-radius: 20px;
    background: #F2F4F7;
    border: 1px #ccc solid;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 4;
    padding: 20px;
}

.pop h3 {
    font-size: 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.pop i {
    font-size: 16px;
    cursor: pointer;
}

.pop .token {
    display: flex;
}

.pop .input {
    display: flex;
    margin-top: 20px;
    height: 56px;
    background: #FFFFFF;
    border: 0.5px solid #CCCCCC;
    border-radius: 6px;
}

.pop input {
    width: calc(100% - 140px);
    background: transparent;
    border: none;
    outline: none;
    text-align: right;
    font-size: 18px;
    font-weight: 600;
}

.pop .token {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 10px;
    cursor: pointer;
    user-select: none;
    color: #555;
    width: 140px;
}

.token .lt {
    display: flex;
    align-items: center;
}

.token img {
    width: 24px;
    margin-right: 4px;
    border-radius: 20px;
}

.token .symbol {
    font-size: 14px;
    margin-top: -4px;
}

.pop .action {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 600;
    margin-top: 24px;
    background: #8708A7;
    color: #fff;
    border-radius: 10px;
    height: 56px;
    width: 100%;
    user-select: none;
    cursor: pointer;
}

.pop .button p {
    font-size: 14px;
    text-align: center;
    margin-top: 4px;
}
</style>
