import contract from 'truffle-contract'
import abi from "../../build/contracts/FleepSweeper.json"

const FleepSweeper = {
    getInstance: async function() {
        if (typeof ethereum === 'undefined') return null

        const sweepContract = contract(abi)
        sweepContract.setProvider(ethereum)

        try {
            return await sweepContract.deployed()
        } catch (error) {
            return null
        }
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
    }
}

export default FleepSweeper
