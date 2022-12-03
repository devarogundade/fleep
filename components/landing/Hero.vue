<template>
<section>
    <div class="app-width">
        <div class="hero">
            <h3 class="hero_title">
                {{ $t('hero.f2') }}
                <a :href="localePath('/learn')"><span>{{ $t('hero.ln') }}</span></a>, <a :href="localePath('/#swap')"><span>{{ $t('hero.sw')  }}</span></a>
                {{ $t('hero.and') }} <a :href="localePath('/#earn')"><span>{{ $t('hero.ay') }}</span></a>
            </h3>
            <p class="hero_subtitle">{{ $t('hero.df') }}</p>
            <div class="action">
                <router-link :to="localePath('/learn')">
                    <div class="get_started">{{ $t('hero.lne') }}</div>
                </router-link>
            </div>
            <div class="powered">
                <p>{{ $t('hero.bw') }}</p>
                <div class="images">
                    <img src="/images/polygon.png" alt="">
                    <img src="/images/xend.svg" alt="">
                    <img src="/images/chainlink.png" alt="">
                    <img src="/images/xendbridge.svg" alt="">
                    <img src="/images/moralis.png" alt="">
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    background-image: url('/images/hero-bg.jpg');
    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
}

.app-width {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 850px;
}

.hero {
    width: 1200px;
    max-width: 100%;
    padding-top: 220px;
    padding-bottom: 60px;
    text-align: center;
}

.hero_title,
.hero_title span {
    font-size: 65px;
    line-height: 75px;
    font-weight: 800;
    font-family: 'neue';
    background-image: linear-gradient(to top, #080053 0%, #020077 100%);
    background-clip: text;
    color: transparent;
    z-index: 1;
}

.hero_title span {
    background-image: linear-gradient(#6973fc, #000986);
    text-decoration: underline #000986 4px;
}

.hero_subtitle {
    margin-top: 40px;
    font-size: 28px;
    font-weight: 600;
}

.action {
    display: flex;
    justify-content: center;
}

.get_started {
    width: 300px;
    height: 60px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    font-weight: 600;
    margin-top: 100px;
    background: #efe8f1;
    color: #660180;
    box-shadow: 2px 2px #8708A7;
    border: 1px solid #8708A7;
}

.powered {
    margin-top: 160px;
    width: 100%;
    text-align: left;
}

.images {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 20px;
    margin-top: 10px;
}

.images img {
    height: 40px;
}

@media screen and (max-width: 700px) {
    .hero {
        padding-top: 150px;
    }

    .powered {
        margin-top: 100px;
    }

    .hero_title,
    .hero_title span {
        font-size: 40px;
        line-height: 50px;
    }

    .hero_subtitle {
        margin-top: 24px;
        font-size: 22px;
        font-weight: 600;
    }
}
</style>
