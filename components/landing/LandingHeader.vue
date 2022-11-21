<template>
<section id="header">
    <div class="app-width">
        <div class="header">
            <router-link to="/">
                <div class="logo">
                    <img src="/images/polygon.png" alt="">
                </div>
            </router-link>
            <ul ref="menu">
                <li><a href="/#swap">Swap</a></li>
                <li><a href="/#sweep">Dusts Sweeper</a></li>
                <li><a href="/#earn">Earn & Auto Yield</a></li>
                <!-- <li><a href="/#earn"></a></li> -->
                <li><a href="/#faqs">FAQs</a></li>
            </ul>
            <router-link to="/dapp">
                <div class="action"> Launch App <i class="fi fi-rr-arrow-right"></i></div>
            </router-link>
            <div ref="handburger" id="handburger" v-on:click="onDrawer()">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </div>
</section>
</template>

<script>
export default {
    mounted() {
        window.addEventListener('scroll', (e) => {
            const header = document.getElementById('header')
            header.classList.toggle('blur', window.pageYOffset > 5)
        })
    },
    methods: {
        onDrawer: function () {
            this.$refs["handburger"].classList.toggle("open")
            this.$refs["menu"].classList.toggle("open-menu")
            this.showBuild = false
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
    background: transparent;
}

.blur {
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
    gap: 100px;
}

ul {
    display: flex;
    align-items: center;
    gap: 40px;
    width: 100%;
    margin-top: -4px;
}

li a {
    font-size: 16px;
    font-weight: 600;
    color: #000;
}

.action {
    padding: 16px 24px;
    border-radius: 30px;
    width: 200px;
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

#handburger {
    display: none;
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
