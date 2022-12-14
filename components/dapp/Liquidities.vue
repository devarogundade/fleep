<template>
<section>
    <Loading v-if="booting" />
    <div v-else class="app-width">
        <div class="earnings">
            <div class="welcome" v-if="!user">
                <h3 v-if="address">Hi, {{
                  address.substring(0, 5) +
                  "..." +
                  address.substring(address.length - 5, address.length)
                }}</h3>

                <div class="benefits">
                    <div class="benefit">
                        <img src="/images/provide.png" alt="" />
                        <p>1. Earn from liquidity</p>
                        <p>Earn $FLP tokens as reward for providing liquidities.</p>
                    </div>
                    <div class="benefit">
                        <img src="/images/interest.png" alt="" />
                        <p>2. Earn up to 15% APY</p>
                        <p>Boost your portfolio up to 15% per annual with AutoYield.</p>
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
                            <div class="av" v-if="user">
                                <p>Auto Stake FLP <i class="fi fi-rr-info"></i></p>
                                <label class="switch">
                                    <input type="checkbox" v-model="user.autoStake" v-on:change="updateProfile($event)">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                            <i class="fi fi-rr-refresh"></i>
                        </div>

                        <div class="entity">
                            <div class="label">
                                <p>Earnings</p>
                                <p>Available: <span>{{ user.balance }}</span></p>
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
                                Stake FLP
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

                        <div class="exchange">
                            <p>Total Earned:</p>
                            <p>{{ user.totalEarned }} FLP</p>
                        </div>
                    </div>
                    <div class="liquidities">
                        <h3>My Liquidities</h3>
                        <div class="liquidity" v-for="(liquidity, index) in liquidities" :key="index">
                            <div class="images">
                                <img :src="liquidity.tokens.token0.image" alt="">
                                <img :src="liquidity.tokens.token1.image" alt="">
                            </div>
                            <p class="name">{{ `${liquidity.tokens.token0.name} / ${liquidity.tokens.token1.name}` }}</p>
                            <p class="name">{{ liquidity.amount0 }} {{ liquidity.tokens.token0.symbol }} / {{ liquidity.amount1 }} {{ liquidity.tokens.token1.symbol }}</p>
                            <div class="action">
                                <div class="add-liquid" v-if="removing == liquidity.liquidId">
                                    <SoTinyProgressBlack />
                                </div>
                                <div class="add-liquid" v-on:click="removeLiquidity(liquidity.liquidId)" v-else>Withdraw</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import Authenticate from "~/static/scripts/Authenticate";
import FleepSwap from "~/static/scripts/FleepSwap";
import FleepVault from "~/static/scripts/FleepVault";
import Network from "~/static/scripts/Network";
import Utils from "~/static/scripts/Utils";
import mainnetPools from "../../static/pools/mainnet.json";
import testnetPools from "../../static/pools/testnet.json";
import testnetTokens from "../../static/tokens/testnet.json";
import mainnetTokens from "../../static/tokens/mainnet.json";

export default {
    data() {
        return {
            user: null,
            booting: true,
            network: Network.current() == "true",
            to: {
                balance: "?????????",
                amount: "",
                token: {
                    symbol: "FLP",
                    image: "/images/flp.png",
                },
            },
            address: null,
            pools: [],
            tokens: [],
            liquidities: [],

            // progress
            creating: false,
            moving: false,
            claiming: false,
            removing: -1
        };
    },
    mounted() {
        if (this.network) {
            // mainnet
            this.pools = mainnetPools;
            this.tokens = mainnetTokens;
        } else {
            // testnet
            this.pools = testnetPools;
            this.tokens = testnetTokens;
        }

        this.getUser();
        this.getLiquidities()
    },
    methods: {
        poolTokens: function (id) {
            const pool = this.pools.filter(p => p.id == id)[0]
            if (!pool) return -1
            return {
                token0: this.tokens.filter(t => t.address.toLowerCase() == pool.token0.toLowerCase())[0],
                token1: this.tokens.filter(t => t.address == pool.token1)[0]
            }
        },
        getLiquidities: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address;
            const response = await FleepSwap.getLiquidities(address)
            if (!response) return

            const poolIds = response[0];
            const amounts0 = response[1];
            const amounts1 = response[2];
            const liquidIds = response[3];

            for (let index = 0; index < poolIds.length; index++) {
                const tokens = this.poolTokens(poolIds[index])
                if (tokens == -1) continue
                this.liquidities.push({
                    poolId: poolIds[index],
                    tokens: tokens,
                    amount0: Utils.toMoney(Utils.fromWei(amounts0[index])),
                    amount1: Utils.toMoney(Utils.fromWei(amounts1[index])),
                    liquidId: liquidIds[index]
                })
            }
        },
        getUser: async function () {
            this.address = (await Authenticate.getUserAddress(this.network)).address;
            const response = await FleepSwap.provider(this.address);

            if (!response) return;

            const user = {
                id: Number(response.id),
                balance: Utils.toMoney(Utils.fromWei(response.balance), 4),
                totalEarned: Utils.toMoney(Utils.fromWei(response.totalEarned), 4),
                vaultAddress: response.vaultAddress,
                autoStake: response.autoStake
            };

            if (user.id > 0) {
                this.user = user;
            }

            this.booting = false;
        },
        getStarted: async function () {
            const address = (await Authenticate.getUserAddress(this.network)).address;
            this.creating = true

            // create provider profile
            await FleepSwap.unlockProvider(address);
            this.creating = false

            this.getUser();
        },
        moveToVault: async function () {
            // if connection is not on mainnet
            if (!this.network) {
                alert('Switch to Mainnet')
                return
            }

            if (this.to.amount == "") return;
            const address = (await Authenticate.getUserAddress(this.network)).address;

            this.moving = true

            // claim the funds to the user wallet first
            const amount = await this.claim()
            if (amount == 0) return

            // deposit from the user wallet to xend xAuto
            const deposit = await FleepVault.deposit(amount, address)

            this.moving = false
        },
        claim: async function () {
            if (this.to.amount == "") return 0;
            const address = (await Authenticate.getUserAddress(this.network)).address;

            this.claiming = true

            const amount = Utils.toWei(this.to.amount)
            const response = await FleepSwap.claim(amount, address);

            if (!response.status) {
                this.claiming = false
                return 0
            }

            this.claiming = false
            this.getUser()

            return amount
        },
        updateProfile: async function (event) {
            const autoVault = event.target.checked
            const address = (await Authenticate.getUserAddress(this.network)).address;

            const response = await FleepSwap.updateProfile(autoVault, address)
            if (response.status) {
                this.$emit('trx', response.trx)
            }
        },
        removeLiquidity: async function (id) {
            const address = (await Authenticate.getUserAddress(this.network)).address;
            this.removing = id

            const response = await FleepSwap.removeLiquidity(id, address)
            console.log(response);
            this.removing = -1
        }
    },
};
</script>

<style scoped>
section {
    min-height: 95vh;
    background-color: #ffffff;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='260' height='260' viewBox='0 0 260 260'%3E%3Cg fill-rule='evenodd'%3E%3Cg fill='%23f0ebf7' fill-opacity='0.2'%3E%3Cpath d='M24.37 16c.2.65.39 1.32.54 2H21.17l1.17 2.34.45.9-.24.11V28a5 5 0 0 1-2.23 8.94l-.02.06a8 8 0 0 1-7.75 6h-20a8 8 0 0 1-7.74-6l-.02-.06A5 5 0 0 1-17.45 28v-6.76l-.79-1.58-.44-.9.9-.44.63-.32H-20a23.01 23.01 0 0 1 44.37-2zm-36.82 2a1 1 0 0 0-.44.1l-3.1 1.56.89 1.79 1.31-.66a3 3 0 0 1 2.69 0l2.2 1.1a1 1 0 0 0 .9 0l2.21-1.1a3 3 0 0 1 2.69 0l2.2 1.1a1 1 0 0 0 .9 0l2.21-1.1a3 3 0 0 1 2.69 0l2.2 1.1a1 1 0 0 0 .86.02l2.88-1.27a3 3 0 0 1 2.43 0l2.88 1.27a1 1 0 0 0 .85-.02l3.1-1.55-.89-1.79-1.42.71a3 3 0 0 1-2.56.06l-2.77-1.23a1 1 0 0 0-.4-.09h-.01a1 1 0 0 0-.4.09l-2.78 1.23a3 3 0 0 1-2.56-.06l-2.3-1.15a1 1 0 0 0-.45-.11h-.01a1 1 0 0 0-.44.1L.9 19.22a3 3 0 0 1-2.69 0l-2.2-1.1a1 1 0 0 0-.45-.11h-.01a1 1 0 0 0-.44.1l-2.21 1.11a3 3 0 0 1-2.69 0l-2.2-1.1a1 1 0 0 0-.45-.11h-.01zm0-2h-4.9a21.01 21.01 0 0 1 39.61 0h-2.09l-.06-.13-.26.13h-32.31zm30.35 7.68l1.36-.68h1.3v2h-36v-1.15l.34-.17 1.36-.68h2.59l1.36.68a3 3 0 0 0 2.69 0l1.36-.68h2.59l1.36.68a3 3 0 0 0 2.69 0L2.26 23h2.59l1.36.68a3 3 0 0 0 2.56.06l1.67-.74h3.23l1.67.74a3 3 0 0 0 2.56-.06zM-13.82 27l16.37 4.91L18.93 27h-32.75zm-.63 2h.34l16.66 5 16.67-5h.33a3 3 0 1 1 0 6h-34a3 3 0 1 1 0-6zm1.35 8a6 6 0 0 0 5.65 4h20a6 6 0 0 0 5.66-4H-13.1z'/%3E%3Cpath id='path6_fill-copy' d='M284.37 16c.2.65.39 1.32.54 2H281.17l1.17 2.34.45.9-.24.11V28a5 5 0 0 1-2.23 8.94l-.02.06a8 8 0 0 1-7.75 6h-20a8 8 0 0 1-7.74-6l-.02-.06a5 5 0 0 1-2.24-8.94v-6.76l-.79-1.58-.44-.9.9-.44.63-.32H240a23.01 23.01 0 0 1 44.37-2zm-36.82 2a1 1 0 0 0-.44.1l-3.1 1.56.89 1.79 1.31-.66a3 3 0 0 1 2.69 0l2.2 1.1a1 1 0 0 0 .9 0l2.21-1.1a3 3 0 0 1 2.69 0l2.2 1.1a1 1 0 0 0 .9 0l2.21-1.1a3 3 0 0 1 2.69 0l2.2 1.1a1 1 0 0 0 .86.02l2.88-1.27a3 3 0 0 1 2.43 0l2.88 1.27a1 1 0 0 0 .85-.02l3.1-1.55-.89-1.79-1.42.71a3 3 0 0 1-2.56.06l-2.77-1.23a1 1 0 0 0-.4-.09h-.01a1 1 0 0 0-.4.09l-2.78 1.23a3 3 0 0 1-2.56-.06l-2.3-1.15a1 1 0 0 0-.45-.11h-.01a1 1 0 0 0-.44.1l-2.21 1.11a3 3 0 0 1-2.69 0l-2.2-1.1a1 1 0 0 0-.45-.11h-.01a1 1 0 0 0-.44.1l-2.21 1.11a3 3 0 0 1-2.69 0l-2.2-1.1a1 1 0 0 0-.45-.11h-.01zm0-2h-4.9a21.01 21.01 0 0 1 39.61 0h-2.09l-.06-.13-.26.13h-32.31zm30.35 7.68l1.36-.68h1.3v2h-36v-1.15l.34-.17 1.36-.68h2.59l1.36.68a3 3 0 0 0 2.69 0l1.36-.68h2.59l1.36.68a3 3 0 0 0 2.69 0l1.36-.68h2.59l1.36.68a3 3 0 0 0 2.56.06l1.67-.74h3.23l1.67.74a3 3 0 0 0 2.56-.06zM246.18 27l16.37 4.91L278.93 27h-32.75zm-.63 2h.34l16.66 5 16.67-5h.33a3 3 0 1 1 0 6h-34a3 3 0 1 1 0-6zm1.35 8a6 6 0 0 0 5.65 4h20a6 6 0 0 0 5.66-4H246.9z'/%3E%3Cpath d='M159.5 21.02A9 9 0 0 0 151 15h-42a9 9 0 0 0-8.5 6.02 6 6 0 0 0 .02 11.96A8.99 8.99 0 0 0 109 45h42a9 9 0 0 0 8.48-12.02 6 6 0 0 0 .02-11.96zM151 17h-42a7 7 0 0 0-6.33 4h54.66a7 7 0 0 0-6.33-4zm-9.34 26a8.98 8.98 0 0 0 3.34-7h-2a7 7 0 0 1-7 7h-4.34a8.98 8.98 0 0 0 3.34-7h-2a7 7 0 0 1-7 7h-4.34a8.98 8.98 0 0 0 3.34-7h-2a7 7 0 0 1-7 7h-7a7 7 0 1 1 0-14h42a7 7 0 1 1 0 14h-9.34zM109 27a9 9 0 0 0-7.48 4H101a4 4 0 1 1 0-8h58a4 4 0 0 1 0 8h-.52a9 9 0 0 0-7.48-4h-42z'/%3E%3Cpath d='M39 115a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm6-8a6 6 0 1 1-12 0 6 6 0 0 1 12 0zm-3-29v-2h8v-6H40a4 4 0 0 0-4 4v10H22l-1.33 4-.67 2h2.19L26 130h26l3.81-40H58l-.67-2L56 84H42v-6zm-4-4v10h2V74h8v-2h-8a2 2 0 0 0-2 2zm2 12h14.56l.67 2H22.77l.67-2H40zm13.8 4H24.2l3.62 38h22.36l3.62-38z'/%3E%3Cpath d='M129 92h-6v4h-6v4h-6v14h-3l.24 2 3.76 32h36l3.76-32 .24-2h-3v-14h-6v-4h-6v-4h-8zm18 22v-12h-4v4h3v8h1zm-3 0v-6h-4v6h4zm-6 6v-16h-4v19.17c1.6-.7 2.97-1.8 4-3.17zm-6 3.8V100h-4v23.8a10.04 10.04 0 0 0 4 0zm-6-.63V104h-4v16a10.04 10.04 0 0 0 4 3.17zm-6-9.17v-6h-4v6h4zm-6 0v-8h3v-4h-4v12h1zm27-12v-4h-4v4h3v4h1v-4zm-6 0v-8h-4v4h3v4h1zm-6-4v-4h-4v8h1v-4h3zm-6 4v-4h-4v8h1v-4h3zm7 24a12 12 0 0 0 11.83-10h7.92l-3.53 30h-32.44l-3.53-30h7.92A12 12 0 0 0 130 126z'/%3E%3Cpath d='M212 86v2h-4v-2h4zm4 0h-2v2h2v-2zm-20 0v.1a5 5 0 0 0-.56 9.65l.06.25 1.12 4.48a2 2 0 0 0 1.94 1.52h.01l7.02 24.55a2 2 0 0 0 1.92 1.45h4.98a2 2 0 0 0 1.92-1.45l7.02-24.55a2 2 0 0 0 1.95-1.52L224.5 96l.06-.25a5 5 0 0 0-.56-9.65V86a14 14 0 0 0-28 0zm4 0h6v2h-9a3 3 0 1 0 0 6H223a3 3 0 1 0 0-6H220v-2h2a12 12 0 1 0-24 0h2zm-1.44 14l-1-4h24.88l-1 4h-22.88zm8.95 26l-6.86-24h18.7l-6.86 24h-4.98zM150 242a22 22 0 1 0 0-44 22 22 0 0 0 0 44zm24-22a24 24 0 1 1-48 0 24 24 0 0 1 48 0zm-28.38 17.73l2.04-.87a6 6 0 0 1 4.68 0l2.04.87a2 2 0 0 0 2.5-.82l1.14-1.9a6 6 0 0 1 3.79-2.75l2.15-.5a2 2 0 0 0 1.54-2.12l-.19-2.2a6 6 0 0 1 1.45-4.46l1.45-1.67a2 2 0 0 0 0-2.62l-1.45-1.67a6 6 0 0 1-1.45-4.46l.2-2.2a2 2 0 0 0-1.55-2.13l-2.15-.5a6 6 0 0 1-3.8-2.75l-1.13-1.9a2 2 0 0 0-2.5-.8l-2.04.86a6 6 0 0 1-4.68 0l-2.04-.87a2 2 0 0 0-2.5.82l-1.14 1.9a6 6 0 0 1-3.79 2.75l-2.15.5a2 2 0 0 0-1.54 2.12l.19 2.2a6 6 0 0 1-1.45 4.46l-1.45 1.67a2 2 0 0 0 0 2.62l1.45 1.67a6 6 0 0 1 1.45 4.46l-.2 2.2a2 2 0 0 0 1.55 2.13l2.15.5a6 6 0 0 1 3.8 2.75l1.13 1.9a2 2 0 0 0 2.5.8zm2.82.97a4 4 0 0 1 3.12 0l2.04.87a4 4 0 0 0 4.99-1.62l1.14-1.9a4 4 0 0 1 2.53-1.84l2.15-.5a4 4 0 0 0 3.09-4.24l-.2-2.2a4 4 0 0 1 .97-2.98l1.45-1.67a4 4 0 0 0 0-5.24l-1.45-1.67a4 4 0 0 1-.97-2.97l.2-2.2a4 4 0 0 0-3.09-4.25l-2.15-.5a4 4 0 0 1-2.53-1.84l-1.14-1.9a4 4 0 0 0-5-1.62l-2.03.87a4 4 0 0 1-3.12 0l-2.04-.87a4 4 0 0 0-4.99 1.62l-1.14 1.9a4 4 0 0 1-2.53 1.84l-2.15.5a4 4 0 0 0-3.09 4.24l.2 2.2a4 4 0 0 1-.97 2.98l-1.45 1.67a4 4 0 0 0 0 5.24l1.45 1.67a4 4 0 0 1 .97 2.97l-.2 2.2a4 4 0 0 0 3.09 4.25l2.15.5a4 4 0 0 1 2.53 1.84l1.14 1.9a4 4 0 0 0 5 1.62l2.03-.87zM152 207a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm6 2a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm-11 1a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm-6 0a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm3-5a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm-8 8a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm3 6a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm0 6a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm4 7a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm5-2a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm5 4a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm4-6a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm6-4a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm-4-3a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm4-3a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm-5-4a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm-24 6a1 1 0 1 1 2 0 1 1 0 0 1-2 0zm16 5a5 5 0 1 0 0-10 5 5 0 0 0 0 10zm7-5a7 7 0 1 1-14 0 7 7 0 0 1 14 0zm86-29a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm19 9a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm-14 5a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm-25 1a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm5 4a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm9 0a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm15 1a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm12-2a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm-11-14a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm-19 0a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm6 5a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm-25 15c0-.47.01-.94.03-1.4a5 5 0 0 1-1.7-8 3.99 3.99 0 0 1 1.88-5.18 5 5 0 0 1 3.4-6.22 3 3 0 0 1 1.46-1.05 5 5 0 0 1 7.76-3.27A30.86 30.86 0 0 1 246 184c6.79 0 13.06 2.18 18.17 5.88a5 5 0 0 1 7.76 3.27 3 3 0 0 1 1.47 1.05 5 5 0 0 1 3.4 6.22 4 4 0 0 1 1.87 5.18 4.98 4.98 0 0 1-1.7 8c.02.46.03.93.03 1.4v1h-62v-1zm.83-7.17a30.9 30.9 0 0 0-.62 3.57 3 3 0 0 1-.61-4.2c.37.28.78.49 1.23.63zm1.49-4.61c-.36.87-.68 1.76-.96 2.68a2 2 0 0 1-.21-3.71c.33.4.73.75 1.17 1.03zm2.32-4.54c-.54.86-1.03 1.76-1.49 2.68a3 3 0 0 1-.07-4.67 3 3 0 0 0 1.56 1.99zm1.14-1.7c.35-.5.72-.98 1.1-1.46a1 1 0 1 0-1.1 1.45zm5.34-5.77c-1.03.86-2 1.79-2.9 2.77a3 3 0 0 0-1.11-.77 3 3 0 0 1 4-2zm42.66 2.77c-.9-.98-1.87-1.9-2.9-2.77a3 3 0 0 1 4.01 2 3 3 0 0 0-1.1.77zm1.34 1.54c.38.48.75.96 1.1 1.45a1 1 0 1 0-1.1-1.45zm3.73 5.84c-.46-.92-.95-1.82-1.5-2.68a3 3 0 0 0 1.57-1.99 3 3 0 0 1-.07 4.67zm1.8 4.53c-.29-.9-.6-1.8-.97-2.67.44-.28.84-.63 1.17-1.03a2 2 0 0 1-.2 3.7zm1.14 5.51c-.14-1.21-.35-2.4-.62-3.57.45-.14.86-.35 1.23-.63a2.99 2.99 0 0 1-.6 4.2zM275 214a29 29 0 0 0-57.97 0h57.96zM72.33 198.12c-.21-.32-.34-.7-.34-1.12v-12h-2v12a4.01 4.01 0 0 0 7.09 2.54c.57-.69.91-1.57.91-2.54v-12h-2v12a1.99 1.99 0 0 1-2 2 2 2 0 0 1-1.66-.88zM75 176c.38 0 .74-.04 1.1-.12a4 4 0 0 0 6.19 2.4A13.94 13.94 0 0 1 84 185v24a6 6 0 0 1-6 6h-3v9a5 5 0 1 1-10 0v-9h-3a6 6 0 0 1-6-6v-24a14 14 0 0 1 14-14 5 5 0 0 0 5 5zm-17 15v12a1.99 1.99 0 0 0 1.22 1.84 2 2 0 0 0 2.44-.72c.21-.32.34-.7.34-1.12v-12h2v12a3.98 3.98 0 0 1-5.35 3.77 3.98 3.98 0 0 1-.65-.3V209a4 4 0 0 0 4 4h16a4 4 0 0 0 4-4v-24c.01-1.53-.23-2.88-.72-4.17-.43.1-.87.16-1.28.17a6 6 0 0 1-5.2-3 7 7 0 0 1-6.47-4.88A12 12 0 0 0 58 185v6zm9 24v9a3 3 0 1 0 6 0v-9h-6z'/%3E%3Cpath d='M-17 191a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm19 9a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2H3a1 1 0 0 1-1-1zm-14 5a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm-25 1a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm5 4a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm9 0a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm15 1a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm12-2a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2H4zm-11-14a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm-19 0a1 1 0 0 0 0 2h2a1 1 0 0 0 0-2h-2zm6 5a1 1 0 0 1 1-1h2a1 1 0 0 1 0 2h-2a1 1 0 0 1-1-1zm-25 15c0-.47.01-.94.03-1.4a5 5 0 0 1-1.7-8 3.99 3.99 0 0 1 1.88-5.18 5 5 0 0 1 3.4-6.22 3 3 0 0 1 1.46-1.05 5 5 0 0 1 7.76-3.27A30.86 30.86 0 0 1-14 184c6.79 0 13.06 2.18 18.17 5.88a5 5 0 0 1 7.76 3.27 3 3 0 0 1 1.47 1.05 5 5 0 0 1 3.4 6.22 4 4 0 0 1 1.87 5.18 4.98 4.98 0 0 1-1.7 8c.02.46.03.93.03 1.4v1h-62v-1zm.83-7.17a30.9 30.9 0 0 0-.62 3.57 3 3 0 0 1-.61-4.2c.37.28.78.49 1.23.63zm1.49-4.61c-.36.87-.68 1.76-.96 2.68a2 2 0 0 1-.21-3.71c.33.4.73.75 1.17 1.03zm2.32-4.54c-.54.86-1.03 1.76-1.49 2.68a3 3 0 0 1-.07-4.67 3 3 0 0 0 1.56 1.99zm1.14-1.7c.35-.5.72-.98 1.1-1.46a1 1 0 1 0-1.1 1.45zm5.34-5.77c-1.03.86-2 1.79-2.9 2.77a3 3 0 0 0-1.11-.77 3 3 0 0 1 4-2zm42.66 2.77c-.9-.98-1.87-1.9-2.9-2.77a3 3 0 0 1 4.01 2 3 3 0 0 0-1.1.77zm1.34 1.54c.38.48.75.96 1.1 1.45a1 1 0 1 0-1.1-1.45zm3.73 5.84c-.46-.92-.95-1.82-1.5-2.68a3 3 0 0 0 1.57-1.99 3 3 0 0 1-.07 4.67zm1.8 4.53c-.29-.9-.6-1.8-.97-2.67.44-.28.84-.63 1.17-1.03a2 2 0 0 1-.2 3.7zm1.14 5.51c-.14-1.21-.35-2.4-.62-3.57.45-.14.86-.35 1.23-.63a2.99 2.99 0 0 1-.6 4.2zM15 214a29 29 0 0 0-57.97 0h57.96z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
    background-size: cover;
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
    background: #F2F4F7;
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
    padding: 0 24px;
    height: 55px;
    border-radius: 30px;
    margin-top: 40px;
    width: 240px;
    font-size: 20px;
    background: #8708A7;
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

.loading {
    width: 100%;
    height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.form {
    width: 400px;
    max-width: 100%;
    max-width: 100%;
    height: fit-content;
    padding: 20px;
    border-radius: 16px;
    background: #F2F4F7;
    border: 1px #ccc solid;
}

.toolbar {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;
}

.toolbar>i {
    height: 36px;
    width: 36px;
    color: #8708A7;
    background: #FFFFFF;
    border-radius: 6px;
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
    color: #464754;
}

.entity .label p:nth-child(1) {
    font-weight: 600;
}


.entity .label p:nth-child(2) {
    cursor: pointer;
}

.entity .label p:nth-child(2) span {
    font-weight: 600;
}

.entity .token {
    display: flex;
}

.entity .input {
    display: flex;
    margin-top: 20px;
    height: 56px;
    background: #FFFFFF;
    border: 0.5px solid #CCCCCC;
    border-radius: 6px;
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

.form .action {
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

.swap .claim {
    border: 1px #8708A7 solid;
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

.av {
    display: flex;
    gap: 10px;
    justify-content: center;
    align-items: center;
}

.av p {
    font-size: 12px;
}

/* The switch - the box around the slider */
.switch {
    position: relative;
    display: inline-block;
    width: 60px;
    height: 34px;
}

/* Hide default HTML checkbox */
.switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

/* The slider */
.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    -webkit-transition: .4s;
    transition: .4s;
}

.slider:before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    -webkit-transition: .4s;
    transition: .4s;
}

input:checked+.slider {
    background-color: #2196F3;
}

input:focus+.slider {
    box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
    -webkit-transform: translateX(26px);
    -ms-transform: translateX(26px);
    transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
    border-radius: 34px;
}

.slider.round:before {
    border-radius: 50%;
}

.exchange {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 14px;
}

.liquidities {
    width: 550px;
    height: fit-content;
    display: flex;
    flex-direction: column;
    gap: 10px;
    border-radius: 16px;
}

.liquidity {
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

.liquidity:hover {
    background: #e7e7e7;
}

.liquidity:first-child {
    height: 40px;
    background: transparent;
}

.liquidity:first-child p {
    font-family: 'neue';
}

.liquidity .images {
    display: flex;
    align-items: center;
}

.liquidity img {
    height: 30px;
    width: 30px;
    object-fit: cover;
    border-radius: 20px;
}

.liquidity img:nth-child(2) {
    margin-left: -12px;
}

.liquidity .name {
    margin-top: -4px;
    font-size: 14px;
    width: 400px;
}

.liquidity .action {
    margin-top: -4px;
    font-size: 16px;
    width: 300px;
    display: flex;
    justify-content: flex-end;
}

.add-liquid {
    width: 120px;
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
