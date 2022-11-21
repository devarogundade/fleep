<template>
<section id="sweep">
    <div class="app-width">
        <div class="tag">Sweep Dusts</div>
        <div class="sweeper">
            <div class="text">
                <div>
                    <h3>Covert Your Low-Value Assets to $MATIC</h3>
                    <p>With a single click on a button, swap all your assets lesser than $20 dollars to $MATIC.</p>
                </div>
                <div class="action">Sweep Dusts</div>
            </div>
            <div class="image">
                <img src="/images/swap.png" alt="">
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

.text div:first-child {
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
</style>
