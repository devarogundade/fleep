export default {
    ssr: false,

    target: 'static',

    env: {
        MORALIS_KEY: process.env.MORALIS_KEY,
        PRIVATE_KEY: process.env.PRIVATE_KEY,
        FIREBASE_API_KEY: process.env.FIREBASE_API_KEY,
        FIREBASE_AUTH_DOMAIN: process.env.FIREBASE_AUTH_DOMAIN,
        FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID,
        FIREBASE_STORAGE_BUCKET: process.env.FIREBASE_STORAGE_BUCKET,
        FIREBASE_MESSAGING_SENDER_ID: process.env.FIREBASE_MESSAGING_SENDER_ID,
        FIREBASE_APP_ID: process.env.FIREBASE_APP_ID,
        FIREBASE_MEASUREMENT_ID: process.env.FIREBASE_MEASUREMENT_ID
    },

    head: {
        title: 'Fleep Finance | A Layer-2 Decentralized App',
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
        '@/plugins/BalanceApi.js',
        '@/plugins/LogsApi.js'
    ],

    modules: [
        '@nuxtjs/axios',
    ],

    axios: {
        baseURL: '/api/v1/',
    },

    build: {
        extend(config, {}) {
            config.node = {
                fs: 'empty',
                net: 'empty',
                express: 'empty'
            }
        }
    },
}