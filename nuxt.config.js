export default {
    ssr: false,

    target: 'static',

    env: {
        MORALIS_KEY: process.env.MORALIS_KEY,
        XEND_BRIDGE_KEY: process.env.XEND_BRIDGE_KEY,
        ALCHEMY_TESTNET_KEY: process.env.ALCHEMY_TESTNET_KEY,
        ALCHEMY_MAINNET_KEY: process.env.ALCHEMY_MAINNET_KEY,
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
        'nuxt-i18n'
    ],

    i18n: {
        locales: [{
                name: 'English',
                code: 'en',
                iso: 'en-US',
                file: 'en-US.js'
            },
            {
                name: 'Afrikaans',
                code: 'af',
                iso: 'af-SA',
                file: 'af-SA.js'
            },
        ],
        langDir: 'localization/',
        defaultLocale: 'en',
    },

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