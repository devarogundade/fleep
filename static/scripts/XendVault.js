import XF from '@xend-finance/web-sdk';

const dotenv = require("dotenv")
dotenv.config()

const PRIVATE_KEY = process.env.PRIVATE_KEY;

const XendVault = {
    instance: null,
    getInstance: async function(network = false) {
        if (this.instance != null) return this.instance

        try {
            const config = network ? { chainId: 137, env: 'mainnet' } : { chainId: 8002, env: 'testnet' }
            this.instance = await XF(config.chainId, PRIVATE_KEY, { env: config.env });
            return this.instance
        } catch (error) {
            return null
        }
    },
    deposit: async function(amount) {
        const instance = await this.getInstance()

        if (instance == null) {
            return {

            }
        }

        try {
            const response = await instance.flexibleDeposit(amount);
            return response;
        } catch (error) {
            return {

            }
        }

    }
}

export default XendVault
