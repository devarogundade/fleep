<template>
<section id="sweep">
    <div class="app-width">
        <div class="tag">{{ $t('sweephero.sp') }}</div>
        <div class="sweeper">
            <div class="text">
                <div>
                    <h3>{{ $t('sweephero.title') }}</h3>
                    <p>{{ $t('sweephero.desc') }}</p>
                </div>
                <router-link :to="localePath('/dapp/sweep')">
                    <div class="action">{{ $t('sweephero.action') }}</div>
                </router-link>
            </div>
            <div class="image">
                <img src="/images/sweep.png" alt="">
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    background-image: url('/images/sweep-hero-bg.jpg');
    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
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
    color: #fff;
}

.text p {
    margin-top: 20px;
    font-size: 18px;
    color: #fff;
    opacity: 0.8;
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
    background: #e8e9f1;
    color: #000986;
    box-shadow: 2px 2px #000986;
    border: 1px solid #000986;
}

.image {
    width: 100%;
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(12px);
    border-radius: 10px;
    margin-top: 60px;
    padding: 60px;
    display: flex;
    justify-content: center;
    border: 1px rgba(255, 255, 255, 0.4) solid;
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
