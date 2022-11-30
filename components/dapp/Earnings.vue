<template>
<section>
    <Loading v-if="booting" />
    <div v-else class="app-width">
        <div class="earnings">
            <div class="welcome" v-if="!user">
                <h3>Hi, 0xb57...b897e</h3>

                <div class="benefits">
                    <div class="benefit">
                        <img src="/images/provide.png" alt="" />
                        <p>1. Earn from liquidity</p>
                        <p>Earn $MATIC tokens as reward for providing liquidities.</p>
                    </div>
                    <div class="benefit">
                        <img src="/images/interest.png" alt="" />
                        <p>2. Earn up to 15% APY</p>
                        <p>Lorem ipsum dolor sit amet quam earum enim dolores.</p>
                    </div>
                </div>

                <div class="button">
                    <div class="action" v-if="!creating" v-on:click="getStarted()">Start Earning!</div>
                    <div class="action" v-else>
                        <TinyProgress />
                    </div>
                </div>
            </div>

            <div class="sweep" v-if="user">
                <div class="swap">
                    <div class="form">
                        <div class="toolbar">
                            <i class="fi fi-rr-refresh"></i>
                        </div>

                        <div class="entity">
                            <div class="label">
                                <p>Earnings</p>
                                <p>Available: {{ user.balance }}</p>
                            </div>
                            <div class="input">
                                <div class="token">
                                    <div class="lt">
                                        <img :src="to.token.image" alt="" />
                                        <p class="symbol">{{ to.token.symbol }}</p>
                                    </div>
                                    <!-- <i class="fi fi-rr-angle-small-down"></i> -->
                                </div>
                                <input v-model="to.amount" type="number" placeholder="0" />
                            </div>
                        </div>

                        <div class="button">
                            <div class="action" v-if="!moving" v-on:click="moveToVault()">
                                Move to vault
                            </div>
                            <div class="action" v-else>
                                <TinyProgress />
                            </div>

                            <div class="action claim" v-if="!claiming" v-on:click="claim()">Claim</div>
                            <div class="action claim" v-else>
                                <TinyProgressBlack />
                            </div>

                            <p>Enter the amount of tokens you want to claim.</p>
                        </div>

                        <div class="divider"></div>

                        <div class="exchange">Total Earned: {{ user.totalEarned }}</div>
                    </div>
                    <div class="dusts"></div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import {
    ModuleFilenameHelpers
} from 'webpack';
import Authenticate from "~/static/scripts/Authenticate";
import FleepSwap from "~/static/scripts/FleepSwap";
import FleepVault from "~/static/scripts/FleepVault";
import Network from "~/static/scripts/Network";
import Utils from "~/static/scripts/Utils";

export default {
    data() {
        return {
            user: null,
            booting: true,
            network: Network.current() == "true",
            to: {
                balance: "•••",
                amount: "",
                token: {
                    symbol: "Matic",
                    image: "https://s2.coinmarketcap.com/static/img/coins/64x64/3890.png",
                },
            },

            // progress
            creating: false,
            moving: false,
            claiming: false
        };
    },
    mounted() {
        this.getUser();
    },
    methods: {
        getUser: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address;
            const response = await FleepSwap.provider(address);

            if (!response) return;

            const user = {
                id: Number(response.id),
                balance: Utils.fromWei(response.balance),
                totalEarned: Utils.fromWei(response.totalEarned),
            };

            if (user.id > 0) {
                this.user = user;
            }

            this.booting = false;
        },
        getStarted: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address;

            this.creating = true

            const response = await FleepVault.getOrCreatePhrase(address);

            if (!response.status) {
                this.creating = ModuleFilenameHelpers
                return
            };

            await FleepSwap.unlockProvider(response.address, address);

            this.creating = false
            this.getUser(address);
        },
        moveToVault: async function () {
            if (this.to.amount == "") return;
            const address = (await Authenticate.getUserAddress(this.network)).address;

            this.moving = true

            const addrResponse = await FleepVault.getOrCreatePhrase(address);
            if (!addrResponse.status) {
                this.moving = false
                return
            };

            const txResponse = await FleepSwap.moveToVault(addrResponse.address);
            if (!txResponse.status) {
                this.moving = false
                return
            }

            const vaultResponse = await FleepVault.deposit(addrResponse.privateKey, 10, this.network);

            this.moving = false
            console.log(vaultResponse);
        },
        claim: async function () {
            if (this.to.amount == "") return;
            const address = (await Authenticate.getUserAddress(this.network)).address;

            this.claiming = true

            const response = await FleepSwap.claim(
                Utils.toWei(this.to.amount),
                address
            );

            if (!response.status) {
                this.claiming = false
                return
            }

            this.claiming = false
            this.getUser()
        },
    },
};
</script>

<style scoped>
section {
    min-height: 90vh;
}

.app-width {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.earnings {
    padding: 150px 0;
}

.welcome {
    padding: 40px;
    border-radius: 16px;
    background-image: linear-gradient(to top, #f3f6fd 0%, #f2f4f7 100%);
    border: 1px #ccc solid;
    width: 600px;
    text-align: center;
}

.welcome h3 {
    font-size: 30px;
    font-family: "neue";
}

.benefits {
    margin-top: 40px;
    display: flex;
    flex-direction: column;
    gap: 30px;
}

.benefit {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.benefit img {
    height: 100px;
    margin-bottom: 10px;
}

.benefit p:nth-child(2) {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 4px;
}

.benefit p:nth-child(3) {
    font-size: 16px;
}

.welcome .button {
    display: flex;
    justify-content: center;
}

.welcome .action {
    padding: 16px 24px;
    border-radius: 30px;
    margin-top: 40px;
    width: 240px;
    font-size: 20px;
    background: #8708a7;
    font-size: 15px;
    font-weight: 600;
    display: flex;
    color: #ffffff;
    cursor: pointer;
    justify-content: center;
    gap: 20px;
    align-items: center;
    user-select: none;
}

.swap {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    width: 100%;
    gap: 40px;
}

.dusts {
    width: 450px;
    height: fit-content;
    display: flex;
    flex-direction: column;
    gap: 10px;
    border-radius: 16px;
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

.swap .action {
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

.swap .claim {
    border: 1px #8708a7 solid;
    background: #fff;
    color: #010101;
    margin-top: 10px;
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
</style>
