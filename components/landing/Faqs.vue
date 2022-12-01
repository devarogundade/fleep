<template>
<section id="faqs">
    <div class="app-width">
        <div class="faq">
            <h3>Frequently Asked Questions</h3>

            <div class="items">
                <div v-for="(faq, index) in faqs" :key="faq.question" :class="show == index ? 'show item' : 'item'">
                    <div class="question" v-on:click="openFaq(index)">
                        <p>{{ faq.question }}</p>
                        <div class="handle">
                            <div></div>
                            <div></div>
                        </div>
                    </div>
                    <div class="answer">
                        <p>{{ faq.answer }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
export default {
    data() {
        return {
            show: -1,
            faqs: [{
                    question: 'What is dusts sweeping?',
                    answer: 'Dusts sweeping simply means converting all your low value assets(<$20) to MATIC all at once.'
                },
                {
                    question: 'How can I start earning?',
                    answer: 'When you provide liquidities to a fleep pool, you\'ll earn a share in MATIC whenever a swap is perform on the pool, plus up to 15% Interest on your earnings per annual.'
                }, {
                    question: 'What is assets swapping?',
                    answer: 'Assets swapping simply means exchanging one asset for another with exact same market value.'
                }, {
                    question: 'What is AutoYield?',
                    answer: 'AutoYield is a Xend Finance infrastructure based on two layer-2 DeFi protocols called xVault and xAuto protocol.'
                },
                {
                    question: 'Which chains and networks are supported?',
                    answer: 'Fleep works on both polygon testnet and mainnet.'
                }, {
                    question: 'Can I create a new pool or liquidity bucket?',
                    answer: 'Go to earnings, click on \'Start Earning\' if you are new, then go to pools to new pools or liquidity buckets.'
                }
            ]
        }
    },

    methods: {
        openFaq(index) {
            if (this.show == index) {
                this.show = -1
            } else {
                this.show = index
            }
        }
    }
}
</script>

<style scoped>
section {
    padding: 100px 0;
}

section h3 {
    text-align: center;
    font-size: 40px;
    font-family: 'neue';
}

.items {
    margin-top: 60px;
    display: flex;
    flex-direction: column;
    align-items: center;
    row-gap: 20px;
    will-change: auto;
}

.item {
    width: 800px;
    max-width: 100%;
    border: 1px solid #ccc;
    border-radius: 16px;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.question {
    height: 100px;
    width: 100%;
    display: grid;
    grid-template-columns: auto 30px;
    column-gap: 10px;
    align-items: center;
    padding: 0 40px;
    cursor: pointer;
}

.question p {
    font-weight: bold;
    font-size: 20px;
    line-height: 20px;
    letter-spacing: 0.02em;
    color: #333;
    transition: .4s;
}

.show .question p {
    color: #8708a7;
}

.answer {
    height: 0;
    transition: .4s;
    padding-left: 40px;
    padding-right: 40px;
    will-change: auto;
}

.show .answer {
    padding-bottom: 40px;
    height: fit-content !important;
}

.answer p {
    font-weight: 400;
    font-size: 20px;
    line-height: 40px;
    letter-spacing: 0.02em;
    color: #555;
    transition: .4s;
}

.handle {
    width: 24px;
    height: 24px;
    position: relative;
}

.handle div:first-child {
    position: absolute;
    background: #ccc;
    width: 100%;
    height: 4px;
    border-radius: 2px;
    top: 10px;
    left: 0;
    transition: .4s;
}

.handle div:last-child {
    position: absolute;
    background: #ccc;
    width: 4px;
    height: 100%;
    border-radius: 2px;
    top: 0;
    left: 10px;
    transition: .4s;
}

.show .handle div:last-child {
    transform: rotate(-90deg);
}

.show .handle div {
    background: #8708a7;
}

@media screen and (max-width: 700px) {
    section {
        padding: 50px 0;
    }

    section h3 {
        font-size: 30px;
    }

    .items {
        margin-top: 60px;
    }

    .question {
        padding: 0 20px;
        height: 90px;
    }

    .question p {
        font-size: 18px;
        line-height: 27px;
    }

    .answer p {
        font-size: 18px;
        line-height: 36px;
    }

    .answer {
        padding-left: 20px;
        padding-right: 20px;
    }

    .show .answer {
        padding-bottom: 20px;
    }
}
</style>
