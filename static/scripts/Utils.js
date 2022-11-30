import Web3 from "web3";

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
    toMoney: function(amount) {
        const formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            //minimumFractionDigits: 0,
            //maximumFractionDigits: 0,
        });
        return formatter.format(amount).replace('$', '')
    }
}

export default Utils