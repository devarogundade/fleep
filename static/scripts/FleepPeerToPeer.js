import axios from "axios"
import Network from "./Network"

// UNCOMPLETED

// xend bridge API requires business registration which
// is beyond the scope of this hackathon

// FIAT => CRYPTO will be implemented after this hackathon

const env = require('env')
env.config()

const XEND_BRIDGE_KEY = env.XEND_BRIDGE_KEY

const TESTNET_URL = "https://canary.xendbridge.com/"
const MAINNET_URL = "https://xendbridge.xend.finance/"

const FleepPeerToPeer = {
    network: Network.current() == 'true',
    baseUrl: this.network ? MAINNET_URL : TESTNET_URL,
    getExchangeRate: async function(trade) {

    },
    buyOrder: async function(user, trade) {
        try {
            const params = {
                emailAddress: user.email,
                phoneNumber: user.phone,
                userName: user.name,
                payInCurrencyCode: trade.payInCurrencyCode,
                payInCurrencyNetwork: trade.payInCurrencyNetwork,
                receiveInCurrencyCode: trade.receiveInCurrencyCode,
                receiveInCurrencyNetwork: trade.receiveInCurrencyNetwork,
                orderAmount: trade.orderAmount,
                consumerDepositMethod: {
                    paymentMethod: trade.paymentMethod,
                    paymentData: {
                        accountName: user.accountName,
                        accountNumber: user.accountNumber,
                        bankName: user.bankName
                    }
                },
                consumerReceiptMethod: {
                    paymentMethod: trade.paymentMethod,
                    paymentData: {
                        walletAddress: user.walletAddress,
                        network: trade.network
                    }
                }
            }
            const request = await axios.post(this.baseUrl + 'api/peertopeerorder/buy/initiate', params)
            return request.data
        } catch (error) {
            console.log(error)
            return null
        }
    },
    sellOrder: async function() {

    },
    pendingOrders: async function(user) {
        try {
            const params = { emailAddress: user.email }
            const request = await axios.get(this.baseUrl + 'api/PeerToPeerOrder/ThirdParty/PendingOrder', params)
            return request.data
        } catch (error) {
            console.log(error);
            return null
        }
    },
    cancelOrder: async function(user, trade) {
        try {
            const params = {
                emailAddress: user.email,
                orderReference: trade.orderReference
            }
            const request = await axios.post(this.baseUrl + 'api/PeerToPeerOrder/ThirdParty/Order/Cancel', params)
            return request.data
        } catch (error) {
            console.log(error);
            return null
        }
    },
    markAsPaid: async function() {
        try {
            const params = {
                emailAddress: user.email,
                orderReference: trade.orderReference
            }
            const request = await axios.post(this.baseUrl + 'api/PeerToPeerOrder/ThirdParty/Order/Confirm', params)
            return request.data
        } catch (error) {
            console.log(error);
            return null
        }
    },
    payForOrderBuyer: async function() {

    },
    payForOrderSeller: async function() {

    }
}

export default FleepPeerToPeer