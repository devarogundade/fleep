<template>
<section>
    <div class="app-width">
        <div class="sweep">
            <div class="head">
                <h3>{{ dusts.length }} dusts was found</h3>
                <p>
                    <i class="fi fi-rr-info"></i> Dusts are referred to assets worth
                    less than $20.
                </p>
            </div>
            <div class="swap">
                <div class="dusts">
                    <div class="loading" v-if="findingDusts">Finding Dusts...</div>
                    <div class="dust" v-for="(dust, index) in dusts" :key="index">
                        <div>
                            <img :src="dust.data1.image" alt="" />
                            <div class="name">
                                <p>{{ dust.data0.name }}</p>
                                <p>{{ fromWeiMoney(dust.balance) }} {{ dust.data0.symbol }}</p>
                            </div>
                        </div>
                        <div>
                            <p class="balance">$ {{ dust.amount }}</p>
                            <input type="checkbox" v-model="dust.selected" />
                        </div>
                    </div>
                </div>
                <div class="form">
                    <div class="toolbar">
                        <i class="fi fi-rr-refresh"></i>
                    </div>

                    <div class="entity">
                        <div class="label">
                            <p>To</p>
                            <p>Available: {{ to.balance }}</p>
                        </div>
                        <div class="input">
                            <div class="token">
                                <div class="lt">
                                    <img :src="to.token.image" alt="" />
                                    <p class="symbol">{{ to.token.symbol }}</p>
                                </div>
                                <!-- <i class="fi fi-rr-angle-small-down"></i> -->
                            </div>
                            <input v-model="to.amount" type="number" placeholder="0" disabled />
                        </div>
                    </div>
                    <p class="fee" v-if="to.amount != ''">Sweep fee: {{ (to.amount / 1000) * 25 }} {{ to.token.symbol }}</p>

                    <div class="button">
                        <div class="action" v-if="!sweeping" v-on:click="sweep()">
                            Sweep
                        </div>
                        <div class="action" v-else>•••</div>
                        <p>Enter the amount of tokens you want to swap.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import Authenticate from "~/static/scripts/Authenticate";
import Network from "~/static/scripts/Network";
import Utils from "~/static/scripts/Utils";
import testnetTokens from "../../static/tokens/testnet.json";
import mainnetTokens from "../../static/tokens/mainnet.json";
import FleepSweeper from "../../static/scripts/FleepSweeper";
import ERC20 from '~/static/scripts/ERC20';
import FleepSwap from '~/static/scripts/FleepSwap';

export default {
    data() {
        return {
            picker: false,
            pickCursor: "from",
            dusts: [],
            supportedTokens: [],
            to: {
                balance: "0",
                amount: "",
                token: {
                    symbol: "USDT",
                    image: "https://s2.coinmarketcap.com/static/img/coins/64x64/825.png",
                },
            },
            network: Network.current() == "true",

            // progress
            findingDusts: true,
            sweeping: false,
        };
    },
    mounted() {
        if (this.network) {
            // mainnet
            this.supportedTokens = mainnetTokens;
        } else {
            // testnet
            this.supportedTokens = testnetTokens;
        }

        this.findDusts();
    },
    methods: {
        switchCursor: function (cursor) {
            this.picker = true;
            this.pickCursor = cursor;
        },
        pickToken: function (token) {
            if (this.pickCursor == "from") {
                this.from.token = token;
            } else {
                this.to.token = token;
            }

            this.picker = false;
        },
        findDusts: async function () {
            this.findingDusts = true;

            const address = (await Authenticate.getUserAddress(this.network)).address;
            const tResponse = await this.$balance.erc20Balances(address, this.network)

            const addresses = [];

            this.supportedTokens.forEach((token) => {
                if (token.address != "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada") {
                    addresses.push(token.address);
                }
            });

            const response = await FleepSweeper.findDusts(addresses, address)
            const dusts = response[0]
            const amountsInUSDT = response[1]

            if (tResponse) {
                for (let index = 0; index < dusts.length; index++) {
                    const dust = dusts[index];
                    let token = tResponse.filter(token => dust.toLowerCase() == token.token_address.toLowerCase())
                    let detail = this.supportedTokens.filter(s => dust.toLowerCase() == s.address.toLowerCase())
                    if (token.length > 0 && detail.length > 0) {
                        this.dusts.push({
                            data0: token[0],
                            data1: detail[0],
                            amount: Utils.toMoney(Utils.fromWei(amountsInUSDT[index])),
                            balance: token[0].balance,
                            selected: true
                        })
                    }
                }
            }

            this.findingDusts = false;

            const estimate = await FleepSweeper.estimate(dusts, address);
            this.to.amount = Utils.fromWei(estimate);
        },
        sweep: async function () {
            const dusts = this.dusts.filter((d) => d.selected);

            const tokens = [];
            dusts.forEach((d) => {
                tokens.push(d.data1.address);
            });

            if (tokens.length == 0) return;

            const address = (await Authenticate.getUserAddress(this.network)).address;
            this.sweeping = true;

            for (let index = 0; index < tokens.length; index++) {
                const allocation = await ERC20.allocation(
                    address,
                    await FleepSwap.getContractAddress(),
                    tokens[index]
                )

                if (allocation >= dusts[index].balance) continue

                await ERC20.approve(
                    address,
                    await FleepSwap.getContractAddress(),
                    dusts[index].balance,
                    tokens[index]
                )
            }

            const response = await FleepSweeper.sweep(tokens, address);
            console.log(response);

            this.sweeping = false;
        },
        fromWeiMoney: function (amount) {
            return Utils.toMoney(Utils.fromWei(amount))
        }
    },
};
</script>

<style scoped>
section {
    background: #fff;
    background-image: url("/images/liquid.svg");
    background-size: cover;
}

.sweep {
    min-height: 95vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 150px 0;
}

.head {
    width: 100%;
    max-width: 890px;
    margin-bottom: 20px;
}

.head h3 {
    font-size: 24px;
    font-family: "neue";
}

.head p {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    padding: 0 2px;
}

.head i {
    margin-top: 4px;
    cursor: pointer;
    color: #8708a7;
}

.swap {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    width: 100%;
    gap: 40px;
}

.dusts h3 {
    font-size: 24px;
    font-family: "neue";
}

.dusts {
    width: 450px;
    height: fit-content;
    display: flex;
    flex-direction: column;
    gap: 10px;
    border-radius: 16px;
}

.dust {
    width: 100%;
    border-radius: 16px;
    background: #eef1f5;
    height: 55px;
    display: flex;
    padding: 0 20px;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    cursor: pointer;
}

.dust>div {
    display: flex;
    align-items: center;
    gap: 16px;
}

.dust .name p {
    margin-top: -4px;
}

.dust .name p:first-child {
    font-size: 16px;
    color: #010101;
}

.dust .name p:last-child {
    font-size: 12px;
    color: #555;
}

.dust .balance {
    font-size: 18px;
    color: #8708a7;
    font-weight: 600;
}

.dust img {
    height: 30px;
    width: 30px;
    object-fit: cover;
    border-radius: 20px;
}

.loading {
    width: 100%;
    height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.form {
    width: 400px;
    height: fit-content;
    padding: 20px;
    border-radius: 16px;
    background-image: linear-gradient(to top, #f3f6fd 0%, #f2f4f7 100%);
    border: 1px #ccc solid;
}

.toolbar {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;
}

.toolbar i {
    height: 36px;
    width: 36px;
    color: #8708a7;
    background: #e6c5ee;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
}

.entity .label {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    margin-top: 24px;
}

.entity .label p {
    color: #555;
}

.entity .label p:nth-child(2) {
    text-decoration: underline;
    cursor: pointer;
    font-weight: 600;
}

.entity .token {
    display: flex;
}

.entity .input {
    display: flex;
    border: #ccc 1px solid;
    margin-top: 6px;
    border-radius: 12px;
    height: 56px;
}

.entity input {
    width: calc(100% - 140px);
    background: transparent;
    border: none;
    outline: none;
    text-align: right;
    font-size: 18px;
    font-weight: 600;
}

.entity .token {
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

.token i {
    width: 24px;
    margin-left: 10px;
}

.switch {
    display: flex;
    justify-content: center;
    margin-top: 24px;
}

.switch i {
    background: #fff;
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 20px;
    cursor: pointer;
    user-select: none;
}

.rate {
    text-align: center;
    margin-top: 20px;
    font-size: 14px;
}

.action {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 600;
    margin-top: 24px;
    background: #8708a7;
    color: #fff;
    border-radius: 12px;
    height: 56px;
    width: 100%;
    user-select: none;
    cursor: pointer;
}

.button p {
    font-size: 14px;
    text-align: center;
    margin-top: 4px;
}

.divider {
    border-top: 1px #010101 solid;
    margin: 20px 0;
}

.fee {
    color: #D20808;
    font-size: 14px;
    text-align: right;
}
</style>
