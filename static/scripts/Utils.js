import Web3 from "web3";
import axios from "axios"

const Utils = {
    fromWei: function(value) {
        try {
            const web3 = new Web3()
            return web3.utils.fromWei(value, 'ether')
        } catch (error) {
            return null
        }
    },
    toWei: function(value) {
        try {
            const web3 = new Web3()
            return web3.utils.toWei(value, 'ether')
        } catch (error) {
            return null
        }
    },
    formatToDate: function(timestamp) {
        const monthsInWord = [
            'Jan', 'Feb',
            'Mar', 'Apr',
            'May', 'Jun',
            'Jul', 'Aug',
            'Sep', 'Oct',
            'Nov', 'Dec'
        ]

        const date = new Date(timestamp)

        const day = parseInt(date.getUTCDate())
        const month = parseInt(date.getUTCMonth())
        const year = date.getUTCFullYear()

        return `${day} ${monthsInWord[month]}, ${year}`
    },
    toMoney: function(amount, mF = 2) {
        const formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            minimumFractionDigits: mF,
            //maximumFractionDigits: 0,
        });
        return formatter.format(amount).replace('$', '')
    },
    estimateGasFee: async function() {
        try {
            const request = await axios.get('https://gasstation-mainnet.matic.network/v2');
            const response = request.data

            return response ? response.fast.maxFee : 0
        } catch (e) {
            console.log(e);
            return 0;
        }
    }
}

export default Utils