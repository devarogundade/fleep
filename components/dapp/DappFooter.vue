<template>
<section>
    <div class="app-width">
        <div class="creator">
            <div class="flex">
                <p><img src="/images/creator.jfif" alt=""> <a target="_blank" href="https://linktr.ee/devarogundade">DevArogundade</a> </p>
                <p>•</p>
                <p><a target="_blank" href="https://github.com/devarogundade/fleep">GitHub Link</a></p>
                <p>•</p>
                <p><a target="_blank" href="https://polygon.technology/africa-bootcamp/">Hackathon Link</a></p>
                <p>•</p>
                <p>
                    <router-link :to="localePath('/faucet')">Faucet</router-link>
                </p>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding: 30px 0;
    background: #F2F4F7;
    border-top: 1px #ccc solid;
}

img {
    width: 30px;
    height: 30px;
    border-radius: 20px;
    object-fit: cover;
}

.flex {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 40px;
}

.creator {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
}

.creator p {
    margin-top: -4px;
    font-size: 16px;
}

.creator p {
    display: flex;
    align-items: center;
    gap: 4px;
}

a {
    color: teal;
    text-decoration: underline;
}

i {
    margin-top: 6px;
}

@media screen and (max-width: 700px) {
    .flex {
        flex-direction: column;
        gap: 10px;
    }
}
</style>
