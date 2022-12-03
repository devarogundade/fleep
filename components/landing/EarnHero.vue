<template>
<section id="earn">
    <div class="app-width">
        <div class="tag">Earn from Liquidity + Up to 15% APY</div>
        <div class="sweeper">
            <div class="text">
                <div>
                    <h3>Provide Liquidity to Earn and Up to 15% Annual Interest</h3>
                    <p>You will earn $FLP for providing liquidity, and can also earn upto 15% interest on it annually.</p>
                </div>
                <router-link :to="localePath('/dapp/pools')">
                    <div class="action">Provide Liquidity</div>
                </router-link>
            </div>
            <div class="image">
                <img src="/images/liquidity.png" alt="">
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding: 80px;
}

.tag {
    background: #fff;
    border-radius: 20px;
    padding: 10px 20px;
    box-shadow: 0 0 10px #ccc;
    font-size: 16px;
    width: fit-content;
    font-family: 'neue';
}

.sweeper {
    margin-top: 40px;
}

.text {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    gap: 100px;
    justify-content: space-between;
    align-items: center;
}

.text>div {
    width: 600px;
    max-width: 100%;
}

.text h3 {
    font-size: 40px;
    line-height: 50px;
    font-weight: 800;
}

.text p {
    margin-top: 20px;
    font-size: 18px;
}

.action {
    width: 220px;
    height: 60px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    font-weight: 600;
    background: #e6e6e6;
    color: #010101;
    box-shadow: 2px 2px #010101;
    border: 1px solid #010101;
}

.image {
    width: 100%;
    background: rgb(252, 197, 180);
    border-radius: 10px;
    margin-top: 60px;
    padding: 60px;
    display: flex;
    justify-content: center;
}

.image img {
    height: 550px;
}

@media screen and (max-width: 700px) {
    section {
        padding: 40px 0;
    }

    .sweeper {
        margin-top: 20px;
    }

    .text {
        gap: 40px;
    }

    .text h3 {
        font-size: 26px;
        line-height: 36px;
    }

    .text p {
        font-size: 16px;
    }

    .image {
        padding: 30px;
    }

    .image img {
        height: unset;
        width: 100%;
    }

    .action {
        width: 200px;
        height: 50px;
        font-size: 16px;
    }
}
</style>
