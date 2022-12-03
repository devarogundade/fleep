<template>
<div class="bg">
    <div class="box">
        <h3 class="title">We are bringing DEFI closer to you</h3>
        <p class="subtitle">Embrace it in your language..</p>

        <div class="languages">
            <nuxt-link :to="switchLocalePath('en')">
                <div :class="language == 'eng' ? 'language active' : 'language'">
                    <img src="/images/uk.webp" alt="">
                    <div class="text">
                        <p>English</p>
                        <p>Default</p>
                    </div>
                </div>
            </nuxt-link>

            <nuxt-link :to="switchLocalePath('af')">
                <div :class="language == 'pid' ? 'language active' : 'language'">
                    <img src="/images/south-africa.png" alt="">
                    <div class="text">
                        <p>Afrikaans</p>
                        <p>South Africa</p>
                    </div>
                </div>
            </nuxt-link>

            <div class="language nt"> <img src="/images/nigeria-ghana.webp" alt="">
                <div class="text">
                    <p>Pigdin <span>Soon</span></p>
                    <p>Nigeria, Ghana..</p>
                </div>
            </div>

            <div class="language nt">
                <img src="/images/nigeria.png" alt="">
                <div class="text">
                    <p>Hausa <span>Soon</span></p>
                    <p>Nigeria</p>
                </div>
            </div>

        </div>

        <p class="close" v-on:click="$emit('close')">Close</p>
    </div>
</div>
</template>

<script>
export default {
    data() {
        return {
            language: 'eng'
        }
    },
    mounted() {
        document.body.classList.add('modal')
    },
    destroyed() {
        document.body.classList.remove('modal')
    }
}
</script>

<style scoped>
.bg {
    position: fixed;
    z-index: 10;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #8708A7a1;
}

.close {
    text-align: center;
    padding: 10px;
    cursor: pointer;
    user-select: none;
}

.box {
    width: 400px;
    height: fit-content;
    padding: 20px 10px;
    border-radius: 16px;
    background: #F2F4F7;
}

.title {
    font-family: neue;
    font-size: 24px;
    line-height: 24px;
    text-align: center;
}

.subtitle {
    font-size: 14px;
    text-align: center;
    margin-top: 10px;
}

.languages {
    display: flex;
    flex-direction: column;
    margin-top: 20px;
    gap: 10px;
}

.language {
    display: flex;
    align-items: center;
    padding: 10px;
    gap: 10px;
    border-radius: 10px;
    cursor: pointer;
    user-select: none;
}

.language img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.language .text p:first-child {
    font-size: 15px;
    margin-top: -4px;
}

.language .text p:last-child {
    font-size: 12px;
}

.active {
    background: #8708A7;
    color: #fff;
}

.nt {
    cursor: not-allowed;
}

span {
    padding: 0 6px;
    background: #f5e7f0;
    border-radius: 6px;
    border: 1px solid #a70823;
    font-size: 12px;
}
</style>
