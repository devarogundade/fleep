<template>
<section id="header">
    <div class="app-width">
        <div class="header">
            <div class="left">
                <router-link :to="localePath('/dapp')">
                    <div class="logo">
                        <img src="/images/logo.png" alt="">
                    </div>
                </router-link>
                <div class="menu" ref="menu">
                    <ul>
                        <li>
                            <router-link :class="$route.name.startsWith('dapp__') ? 'active' : ''" :to="localePath('/dapp')">Swap</router-link>
                        </li>
                        <li>
                            <router-link :class="$route.name.startsWith('dapp-sweep') ? 'active' : ''" :to="localePath('/dapp/sweep')">Sweep Dust</router-link>
                        </li>
                        <li>
                            <router-link :class="($route.name.startsWith('dapp-pools') || $route.name.startsWith('dapp-liquidity-pool')) ? 'active' : ''" :to="localePath('/dapp/pools')">Pools</router-link>
                        </li>
                        <li>
                            <router-link :class="$route.name.startsWith('dapp-liquidities') ? 'active' : ''" :to="localePath('/dapp/liquidities')">Liquidities</router-link>
                        </li>
                        <li>
                            <router-link :class="$route.name.startsWith('dapp-auto-yield') ? 'active' : ''" :to="localePath('/dapp/auto-yield')">AutoYield</router-link>
                        </li>
                        <li>
                            <router-link :class="$route.name.startsWith('dapp-peer-to-peer') ? 'active' : ''" :to="localePath('/dapp/peer-to-peer')">P2P</router-link>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="right">
                <li v-on:click="language = true">
                    <img src="/images/uk.webp" alt="">
                </li>
                <div class="action" v-if="address">
                    {{
                  address.substring(0, 8) +
                  "..." +
                  address.substring(address.length - 8, address.length)
                }}
                </div>
                <div class="action" v-else v-on:click="connectWallet()">Connect Wallet</div>
                <div ref="handburger" id="handburger" v-on:click="onDrawer()">
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
                <div class="network">
                    <label class="switch">
                        <input v-model="network" v-on:change="switchNetwork($event)" type="checkbox">
                        <span class="slider round"></span>
                    </label>
                    <p>{{ network ? 'Mainnet' : 'Testnet' }}</p>
                </div>
            </div>
        </div>
    </div>

    <Language v-if="language" v-on:close="language = false" />
</section>
</template>

<script>
import Authenticate from '~/static/scripts/Authenticate'
import Network from '~/static/scripts/Network'
export default {
    data() {
        return {
            address: null,
            network: Network.current() == 'true',
            language: false
        }
    },
    created() {
        this.connectWallet()
    },
    methods: {
        onDrawer: function () {
            this.$refs["handburger"].classList.toggle("open")
            this.$refs["menu"].classList.toggle("open-menu")
            this.showBuild = false
        },
        connectWallet: async function () {
            const response = await Authenticate.getUserAddress(this.network)
            if (response.status) {
                this.address = response.address
            }
        },
        switchNetwork: async function (event) {
            Network.updateNetwork(event.target.checked)
            const response = await Authenticate.getUserAddress(this.network)
            if (response.status) {
                this.address = response.address
            }
            location.reload()
        }
    },
}
</script>

<style scoped>
section {
    height: 150px;
    width: 100%;
    position: fixed;
    top: 0;
    left: 0;
    z-index: 10;
    background: rgba(255, 255, 255, 1);
    box-shadow: 0 0 10px #CCC;
    height: 80px;
}

.logo img {
    height: 40px;
}

.app-width,
.header {
    height: 100%;
}

.header {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 100px;
}

.left {
    display: flex;
    align-items: center;
    gap: 100px;
}

.right {
    display: flex;
    align-items: center;
    gap: 40px;
}

ul {
    display: flex;
    align-items: center;
    width: 100%;
    background: rgb(205, 215, 248);
    border-radius: 26px;
    width: fit-content;
    padding: 4px;
}

li a {
    font-size: 16px;
    font-weight: 600;
    color: #010101;
    padding: 8px 20px;
    display: block;
    border-radius: 22px;
}

li img {
    width: 30px;
    height: 24px;
    border-radius: 6px;
    object-fit: cover;
    margin-top: 6px;
    cursor: pointer;
}

li .active {
    background: #000986;
    color: #fff;
}

.action {
    padding: 16px 24px;
    border-radius: 30px;
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

#handburger {
    display: none;
}

.network p {
    font-size: 12px;
    text-align: center;
}

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
    background-color: rgb(168, 23, 23);
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
    background-color: #049b04;
}

input:focus+.slider {
    box-shadow: 0 0 1px #049b04;
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

@media screen and (max-width: 800px) {
    .header {
        justify-content: space-between;
        gap: 10px;
    }

    .action {
        width: 150px;
        padding: 12px 0;
    }

    ul {
        position: fixed;
        width: 100%;
        height: 100%;
        flex-direction: column;
        top: 0;
        left: -100%;
        background: #1900b3;
        padding: 40px;
    }

    li a {
        color: #fff;
        font-size: 20px;
    }

    .open-menu {
        left: 0 !important;
    }

    #handburger {
        width: 32px;
        height: 25px;
        position: relative;
        -webkit-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -o-transform: rotate(0deg);
        transform: rotate(0deg);
        -webkit-transition: 0.5s ease-in-out;
        -moz-transition: 0.5s ease-in-out;
        -o-transition: 0.5s ease-in-out;
        transition: 0.5s ease-in-out;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 100;
    }

    #handburger span {
        display: block;
        position: absolute;
        height: 2px;
        width: 100%;
        background: #000;
        opacity: 1;
        left: 0;
        -webkit-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -o-transform: rotate(0deg);
        transform: rotate(0deg);
        -webkit-transition: 0.25s ease-in-out;
        -moz-transition: 0.25s ease-in-out;
        -o-transition: 0.25s ease-in-out;
        transition: 0.25s ease-in-out;
    }

    #handburger span:nth-child(1) {
        top: 0px;
    }

    #handburger span:nth-child(2),
    #handburger span:nth-child(3) {
        top: 10px;
    }

    #handburger span:nth-child(4) {
        top: 20px;
    }

    #handburger.open span:nth-child(1) {
        top: 10px;
        width: 0%;
        left: 50%;
    }

    #handburger.open span:nth-child(2) {
        -webkit-transform: rotate(45deg);
        -moz-transform: rotate(45deg);
        -o-transform: rotate(45deg);
        transform: rotate(45deg);
    }

    #handburger.open span:nth-child(3) {
        -webkit-transform: rotate(-45deg);
        -moz-transform: rotate(-45deg);
        -o-transform: rotate(-45deg);
        transform: rotate(-45deg);
    }

    #handburger.open span:nth-child(4) {
        top: 18px;
        width: 0%;
        left: 50%;
    }
}
</style>
