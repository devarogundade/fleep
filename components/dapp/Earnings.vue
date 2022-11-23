<template>
<section>
    <Loading v-if="booting" />
    <div v-else class="app-width">
        <div class="earnings" v-if="!user">
            <div class="welcome">
                <h3>Hi, 0xb57...b897e</h3>

                <div class="benefits">
                    <div class="benefit">
                        <img src="/images/provide.png" alt="">
                        <p>1. Earn from liquidity</p>
                        <p>Lorem ipsum dolo, tenetur quam earum enim dolores.</p>
                    </div>
                    <div class="benefit">
                        <img src="/images/interest.png" alt="">
                        <p>2. Earn up to 15% APY</p>
                        <p>Lorem ipsum dolor sit amet quam earum enim dolores.</p>
                    </div>
                </div>

                <div class="button">
                    <div class="action" v-on:click="getStarted()">Start Earning!</div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import Authenticate from '~/static/scripts/Authenticate'
import FleepSwap from '~/static/scripts/FleepSwap'
import Network from '~/static/scripts/Network'

export default {
    data() {
        return {
            user: null,
            booting: true,
            network: Network.current() == 'true'
        }
    },
    mounted() {
        this.getUser()
    },
    methods: {
        getUser: async function () {
            const address = await (await Authenticate.getUserAddress(this.network)).address
            const response = await FleepSwap.provider(address)
            const user = {
                id: Number(response.id),
                balance: Number(response.balance),
                totalEarned: Number(response.totalEarned)
            }

            if (user.id > 0) {
                this.user = user
            }

            this.booting = false
        },
        getStarted: async function () {
            const address = await (await Authenticate.getUserAddress(this.network)).address
            await FleepSwap.unlockProvider(address)
            this.getUser(address)
        }
    }
}
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
    font-family: 'neue';
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

.button {
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
</style>
