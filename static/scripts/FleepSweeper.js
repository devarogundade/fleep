import contract from 'truffle-contract'
import testnetContractJson from "~/build/testnet/Sweeper.json"
import mainnetContractJson from "~/build/mainnet/Sweeper.json"
import Network from './Network'

const FleepSweeper = {
    instance: null,
    network: Network.current() == 'true',
    getAbi: function() { return this.network ? mainnetContractJson : testnetContractJson },
    getInstance: async function() {
        if (this.instance) return this.instance

        if (typeof ethereum === 'undefined') return null

        const sweepContract = contract(this.getAbi())
        sweepContract.setProvider(ethereum)

        try {
            this.instance = await sweepContract.deployed()
            return this.instance
        } catch (error) {
            return null
        }
    },
    estimate: async function(tokens, address) {
        const instance = await this.getInstance()
        if (instance == null) return 0

        return await instance.estimate(tokens, address)
    },
    findDusts: async function(address, amount) {
        const instance = await this.getInstance()
        if (instance == null) return []

        return await instance.findDusts(address, amount)
    },
    sweep: async function(tokens, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to initialize',
            error: null,
            status: false
        }

        try {
            const response = await instance.sweep(tokens, { from: address })
            return {
                message: 'Transaction sent',
                sweep: response,
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




    // test
    updateUSDTPair: async function(pair, address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            message: 'Failed to Initialize',
            error: null,
            status: false
        }

        try {
            const trx = await instance.updateUSDTPair(pair, {
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

export default FleepSweeper