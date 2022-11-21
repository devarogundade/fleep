export default {
    ssr: false,

    target: 'static',

    env: {
        MORALIS_KEY: process.env.MORALIS_KEY,
    },

    head: {
        title: 'Fleep | Polygon Swap and Dusts Sweeper',
        htmlAttrs: {
            lang: 'en'
        },
        meta: [
            { charset: 'utf-8' },
            { name: 'viewport', content: 'width=device-width, initial-scale=1' },
            { hid: 'description', name: 'description', content: '' },
            { name: 'format-detection', content: 'telephone=no' }
        ],
        link: [
            { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
        ]
    },

    css: [
        '@/static/common.css'
    ],

    components: [
        '~/components',
        '~/components/landing',
        '~/components/dapp',
        '~/components/alerts'
    ],

    plugins: [
        '@/plugins/BalanceApi.js'
    ],

    modules: [
        '@nuxtjs/axios',
    ],

    axios: {
        baseURL: '/',
    },
}
