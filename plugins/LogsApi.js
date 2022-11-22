import Vue from "vue";

// injected at nuxt.config.js plugins

export default ({ $axios }, inject) => {
    inject('logs', Vue.observable({
        baseUrl: 'https://deep-index.moralis.io/api/v2/',
        getLogs: async function(address, ABI, topic0, network) {
            const chain = network ? 'polygon' : 'mumbai'

            const options = {
                method: 'GET',
                url: `${this.baseUrl}/${address}/logs`,
                params: { chain: chain, topic0: topic0, limit: '100' },
                headers: {
                    'accept': 'application/json',
                    'X-API-Key': `${process.env.MORALIS_KEY}`
                },
                data: { abi: ABI }
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
