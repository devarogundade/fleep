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
    }
}

export default FleepSweeper
