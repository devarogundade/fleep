<template>
<section>
    <div class="app-width">
        <div class="demo">
            <div class="tag">{{ $t('demo.tag') }}</div>
            <img :src="'/images/banner.png'">
            <a href="/videos/demo.mp4" target="_blank">
                <div class="play">
                    <i class="fi fi-rr-play"></i>
                    <p>{{ $t('demo.play') }}</p>
                </div>
            </a>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding: 60px 0;
    border-bottom: 8px solid #FAFAFA;
}

.app-width {
    display: flex;
    justify-content: center;
}

.demo {
    position: relative;
    height: fit-content;
    background: #000;
    border-radius: 20px;
    max-height: 450px;
    overflow: hidden;
}

img {
    width: 850px;
    max-width: 100%;
    height: fit-content;
    opacity: 0.95;
    object-fit: cover;
}

.tag {
    background: rgb(247, 228, 242);
    font-size: 16px;
    font-weight: 600;
    padding: 3px 10px;
    font-family: neue;
    position: absolute;
    top: 10px;
    left: 10px;
    z-index: 1;
    box-shadow: 0 0 6px #ccc;
    border-radius: 10px;
}

.play {
    position: absolute;
    left: 50%;
    top: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transform: translate(-50%, -50%);
    background: #fff;
    padding: 10px 20px;
    border-radius: 20px;
    gap: 10px;
    color: #000;
    box-shadow: 0 4px 6px #ccc;
}

.play p {
    font-size: 16px;
    font-weight: 600;
}
</style>
