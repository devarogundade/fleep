import Web3 from "web3"
import tokenAbi from "~/static/xend/usdt.json";
import contractAbi from "~/static/xend/usdt-xauto.json"

const FleepVault = {
    tokenAddress: '0xc2132D05D31c914a87C6611C10748AEb04B58e8F',
    contractAddress: '0x143afc138978Ad681f7C7571858FAAA9D426CecE',
    getToken: function() {
        const web3 = new Web3(ethereum)
        return new web3.eth.Contract(tokenAbi, this.tokenAddress)
    },
    getContract: function() {
        const web3 = new Web3(ethereum)
        return new web3.eth.Contract(contractAbi, this.contractAddress)
    },
    approve: async function(amount, address) {
        try {
            const contract = this.getToken()
            await contract.methods.approve(this.contractAddress, amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    deposit: async function(amount, address) {
        try {
            const contract = this.getContract()
            await contract.methods.deposit(amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    withdraw: async function(amount, address) {
        try {
            const contract = this.getContract()
            const sharePrice = await contract.methods.getPricePerFullShare()
            const withdrawAmountInShares = ((amount * 10 ** 24) / sharePrice)
            await contract.methods.withdraw(parseInt(String(withdrawAmountInShares), 10))
                .send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    balance: async function(address) {
        try {
            const contract = this.getToken()
            return await contract.methods.balanceOf(address)
        } catch (error) {
            console.log(error);
            return 0
        }
    },
    savings: async function(address) {
        try {
            const contract = this.getContract()
            const share = await contract.methods.balanceOf(address)
            const sharePrice = await contract.methods.getPricePerFullShare()
            return ((share * sharePrice) / 10 ** 24);
        } catch (error) {
            console.log(error);
            return 0
        }
    }
}

export default FleepVault
