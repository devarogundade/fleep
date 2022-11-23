import contract from 'truffle-contract'
import abi from "../../build/contracts/FleepSwap.json"

const FleepSwap = {
    instance: null,
    getInstance: async function() {
        if (this.instance != null) {
            return this.instance
        }

        if (typeof ethereum === 'undefined') return null

        const swapContract = contract(abi)
        swapContract.setProvider(ethereum)

        try {
            this.instance = await swapContract.deployed()
            return this.instance
        } catch (error) {
            return null
        }
    },
    provider: async function(address) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.providers(address)
        } catch (error) {
            return null
        }
    },
    swap: async function(token0, token1, amount0, poolId) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.swap(token0, token1, amount0, poolId, {
                from: userAddress
            })
            return {
                message: 'Transaction Hash',
                trx: trx,
                status: true
            }
        } catch (error) {
            return {
                message: 'Transaction failed',
                error: error,
                status: false
            }
        }
    },
    getExchangeRate: async function(from, to) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const rate = await instance.getRate(from, to)
            return {
                message: 'Transaction Hash',
                rate: rate,
                status: true
            }
        } catch (error) {
            return {
                message: 'Fetching failed',
                error: error,
                status: false
            }
        }
    },
    getPair: async function(token) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.pairs(token)
        } catch (error) {
            return null
        }
    },
    getPool: async function(id) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.pools(id)
        } catch (error) {
            return null
        }
    },
    getLiquid: async function(id) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.liquids(id)
        } catch (error) {
            return null
        }
    },
    unlockProvider: async function(address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.unlockedProviderAccount({
                from: address
            })
            return {
                message: 'Transaction sent',
                trx: trx,
                status: true
            }
        } catch (error) {
            console.log(error);
            return {
                message: 'Transaction failed',
                error: error,
                status: false
            }
        }
    },

    // testing functions
    createPair: async function(token0, token1, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.createPair(token0, token1, {
                from: address
            })
            return {
                message: 'Transaction sent',
                trx: trx,
                status: true
            }
        } catch (error) {
            return {
                message: 'Transaction failed',
                error: error,
                status: false
            }
        }
    },
    updateNativePair: async function(pair, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.updateNativePair(pair, {
                from: address
            })
            return {
                message: 'Transaction sent',
                trx: trx,
                status: true
            }
        } catch (error) {
            return {
                message: 'Transaction failed',
                error: error,
                status: false
            }
        }
    }
}

export default FleepSwap
