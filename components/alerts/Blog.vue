<template>
<section>
    <div class="app-width">
        <div class="box">
            <i class="fi fi-rr-close" v-on:click="$emit('close')"></i>
            <div class="video"><video controls poster="/images/hero-bg.jpg"></video></div>
            <h3>This is how to swap</h3>
            <p class="desc">
                Lorem ipsum dolor sit amet consectetur adipisicing elit. Perferendis perspiciatis enim illo inventore quod corporis omnis quo tempora. Maiores accusamus ab in beatae voluptatem reiciendis facilis exercitationem quaerat quia facere?
            </p>
            <p class="content">
                Lorem ipsum dolor, sit amet consectetur adipisicing elit. Numquam sunt odit voluptate, earum voluptates delectus distinctio eaque velit quia quam nostrum assumenda soluta, quisquam molestiae quae laboriosam in, voluptatem ratione?
            </p>
        </div>
    </div>
</section>
</template>

<script>
export default {
    mounted() {
        document.body.classList.add('modal')
    },
    destroyed() {
        document.body.classList.remove('modal')
    }
}
</script>

<style scoped>
section {
    position: fixed;
    z-index: 10;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: #8708a7a1;
}

.app-width {
    padding: 50px 0;
    width: 600px;
    overflow-y: scroll;
}

.app-width::-webkit-scrollbar {
    display: none;
}

.box {
    width: 100%;
    background-image: linear-gradient(to top, #f3f6fd 0%, #f2f4f7 100%);
    border-radius: 30px;
    overflow: hidden;
}

video {
    width: 100%;
    height: 350px;
    object-fit: cover;
}

h3 {
    font-size: 30px;
    font-family: neue;
    padding: 10px 20px;
}

.desc {
    padding: 0 20px;
    font-size: 16px;
    font-weight: 600;
}

.content {
    padding: 0 20px;
    padding-top: 20px;
    padding-bottom: 40px;
}
</style>
