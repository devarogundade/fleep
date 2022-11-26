<template>
<div class="box" v-if="data">
    <h3><i class="fi fi-rr-check"></i> {{ data.title }}</h3>
    <p>{{ data.message }}</p>
    <div class="action" v-on:click="$emit('close')">Close</div>
</div>
</template>

<script>
export default {
    props: ['data']
}
</script>

<style scoped>
.box {
    width: 500px;
    max-width: 90%;
    padding: 40px;
    border-radius: 30px;
    background: rgb(222, 255, 222);
    position: fixed;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    box-shadow: 0 4px 8px #ccc;
    z-index: 10;
}

.box h3 {
    color: green;
    font-size: 24px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.box p {
    font-size: 18px;
    line-height: 24px;
}

.action {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    border: 1px #000 solid;
    font-size: 18px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
}

@media screen and (max-width: 1000px) {
    .box {
        left: 50%;
    }
}
</style>
