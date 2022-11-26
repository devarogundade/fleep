import contract from 'truffle-contract'
import abi from "~/build/contracts/FleepSwap.json"

const FleepSwap = {
    instance: null,
    address: '0xE670376fc6e85672b0d5d514bC1B7E8a6760dE4E',
    getInstance: async function() {
        console.log(abi);
        if (this.instance != null) {
            return this.instance
        }

        if (typeof ethereum === 'undefined') return null

        const swapContract = contract(abi)
        swapContract.setProvider(ethereum)

        try {
            this.instance = await swapContract.deployed()
            console.log(instance);
            return this.instance
        } catch (error) {
            console.log(error);
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
    provideLiquidity: async function(amount0, poolId, address) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.provideLiquidity(amount0, poolId, { from: address })
        } catch (error) {
            console.log(error);
            return null
        }
    },
    swap: async function(token0, token1, amount0, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.swap(token0, token1, amount0, {
                from: address
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
            const rate = await instance.estimate(from, to, 1)
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
    getPoolSize: async function(token0, token1) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.getPoolSize(token0, token1)
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
            return {
                message: 'Transaction failed',
                error: error,
                status: false
            }
        }
    },
    createPool: async function(token0, token1, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.createPool(token0, token1, {
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
    claim: async function(amount, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.withDrawEarnings(amount, { from: address })
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
