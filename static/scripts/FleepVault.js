import XF from '@xend-finance/web-sdk';

const dotenv = require("dotenv")
dotenv.config()

const PRIVATE_KEY = process.env.PRIVATE_KEY;

const FleepVault = {
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
    createWallet: async function() {
        const instance = await this.getInstance()
        if (instance == null) return {
            status: false,
            error: null,
            message: 'Failed to initialize'
        }

        try {
            const wallet = await instance.createWallet()
            return {
                status: this,
                wallet: wallet,
                message: 'Failed'
            }
        } catch (error) {
            return {
                status: false,
                error: error,
                message: 'Failed'
            }
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

export default FleepVault
