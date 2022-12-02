import Web3 from "web3"
import tokenAbi from "~/static/vault/token.json";
import contractAbi from "~/static/vault/xauto.json"

const FleepVault = {
    getToken: function(tokenAddress) {
        const web3 = new Web3(ethereum)
        return new web3.eth.Contract(tokenAbi, tokenAddress)
    },
    getContract: function(contractAddress) {
        const web3 = new Web3(ethereum)
        return new web3.eth.Contract(contractAbi, contractAddress)
    },
    approve: async function(amount, address, tokenAddress, contractAddress) {
        try {
            const allocation = await this.allocation(address, tokenAddress, contractAddress)
            if (allocation >= amount) return true

            const contract = this.getToken(tokenAddress)
            await contract.methods.approve(contractAddress, amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    allocation: async function(address, tokenAddress, contractAddress) {
        const contract = this.getToken(tokenAddress)
        try {
            return await contract.methods.allowance(address, contractAddress).call();
        } catch (error) {
            return 0
        }
    },
    deposit: async function(amount, address, contractAddress) {
        try {
            const contract = this.getContract(contractAddress)
            await contract.methods.deposit(amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    withdraw: async function(amount, address, contractAddress) {
        try {
            const contract = this.getContract(contractAddress)
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
    balance: async function(address, tokenAddress) {
        try {
            const contract = this.getToken(tokenAddress)
            return await contract.methods.balanceOf(address)
        } catch (error) {
            console.log(error);
            return 0
        }
    },
    savings: async function(address, contractAddress) {
        try {
            const contract = this.getContract(contractAddress)
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