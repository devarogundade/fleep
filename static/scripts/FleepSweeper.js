import contract from 'truffle-contract'
import abi from "~/build/contracts/Sweeper.json"

const FleepSweeper = {
    instance: null,
    getInstance: async function() {
        if (this.instance) return this.instance

        if (typeof ethereum === 'undefined') return null

        const sweepContract = contract(abi)
        sweepContract.setProvider(ethereum)

        try {
            this.instance = await sweepContract.deployed()
            return this.instance
        } catch (error) {
            return null
        }
    },
    estimate: async function(tokens) {
        const instance = await this.getInstance()
        if (instance == null) return 0

        return await instance.estimate(tokens)
    },
    isDust: async function(address, amount) {

    },
    sweep: async function(tokens, address) {
        const instance = this.getInstance()
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