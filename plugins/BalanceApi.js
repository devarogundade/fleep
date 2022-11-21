import Vue from "vue";

// injected at nuxt.config.js plugins

export default ({ $axios }, inject) => {
    inject('balance', Vue.observable({
        baseUrl: 'https://deep-index.moralis.io/api/v2/',
        maticBalance: async function(address, network) {
            const chain = network ? 'polygon' : 'mumbai'

            const options = {
                method: 'GET',
                url: `${this.baseUrl}/${address}/balance`,
                params: { chain: chain },
                headers: {
                    'accept': 'application/json',
                    'X-API-Key': `${process.env.MORALIS_KEY}`
                }
            }

            try {
                const response = await $axios.request(options)
                return response.data
            } catch (error) {
                return null
            }
        },
        erc20Balances: async function(address, network) {
            const chain = network ? 'polygon' : 'mumbai'

            const options = {
                method: 'GET',
                url: `${this.baseUrl}/${address}/erc20`,
                params: { chain: chain },
                headers: {
                    'accept': 'application/json',
                    'X-API-Key': `${process.env.MORALIS_KEY}`
                }
            }

            try {
                const response = await $axios.request(options)
                return response.data
            } catch (error) {
                return null
            }
        }
    }))
}
