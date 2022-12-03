import contract from 'truffle-contract'
import testnetContractJson from "~/build/testnet/Swap.json"
import mainnetContractJson from "~/build/mainnet/Swap.json"
import Network from './Network';
import Utils from './Utils';

const FleepSwap = {
    instance: null,
    network: Network.current() == 'true',
    getAbi: function() { return this.network ? mainnetContractJson : testnetContractJson },
    getInstance: async function() {
        if (this.instance != null) {
            return this.instance
        }

        if (typeof ethereum === 'undefined') return null

        const swapContract = contract(this.getAbi())
        swapContract.setProvider(ethereum)

        try {
            this.instance = await swapContract.deployed()
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
    provideLiquidity: async function(poolId, amount0, address, value = 0) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.provideLiquidity(poolId, amount0, {
                from: address,
                value: value
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
    removeLiquidity: async function(liquidityId, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.removeLiquidity(liquidityId, {
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
            const rate = await instance.estimate(from, to, Utils.toWei('1'))
            return {
                message: 'Transaction Hash',
                rate: Utils.fromWei(rate),
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
    getLiquidities: async function(address) {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            return await instance.myLiquidities(address)
        } catch (error) {
            return null
        }
    },
    getContractAddress: async function() {
        const instance = await this.getInstance()
        if (instance == null) return null

        try {
            const r = await instance.getContractAddress()
            console.log('addr', r);
            return r
        } catch (error) {
            console.log(error);
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
    moveToVault: async function(vaultAddress) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.withDrawEarningsToVault(vaultAddress, { from: address })
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
    updateProfile: async function(autoVault, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.updateProviderProfile(autoVault, { from: address })
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
    testnetHelper2: async function(address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.testnetHelper2({
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