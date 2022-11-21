import Web3 from "web3"
import ABI from "../utils/aggregatorABI.json"

const PriceApi = {
    price: async function(address) {
        const web3 = new Web3()
        web3.setProvider(ethereum)

        const priceFeed = web3.eth.Contract(ABI, address)
        const data = await priceFeed.methods.latestRoundData().call()
        console.log(data);
    }
}

export default PriceApi
