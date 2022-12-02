import axios from "axios"
import Network from "./Network"

// TO DO

// xendbridge api requires business registration which
// is beyond the scope of this hackathon

// FIAT => CRYPTO will be implemented later in the future

const TESTNET_URL = "https://canary.xendbridge.com"
const MAINNET_URL = "https://xendbridge.xend.finance"

const FleepBuy = {
    network: Network.current() == 'true',
    baseUrl: this.network ? MAINNET_URL : TESTNET_URL,
    buyOrder: async function() {

    }
}

export default FleepBuy