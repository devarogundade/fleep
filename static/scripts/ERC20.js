import Web3 from "web3"
import contractJson from "~/build/contracts/TestnetToken.json"

const ERC20 = {
    abi: contractJson.abi,
    faucet: async function(address, amount, tokenAddress) {
        const web3 = new Web3(ethereum)
        const contract = new web3.eth.Contract(this.abi, tokenAddress)
        try {
            await contract.methods.faucet(address, amount).send({ from: address })
            return true
        } catch (error) {
            return false
        }
    },
    approve: async function(address, spender, amount, tokenAddress) {
        const web3 = new Web3(ethereum)
        console.log(tokenAddress);
        const contract = new web3.eth.Contract(this.abi, tokenAddress)
        try {
            await contract.methods.approve(spender, amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    test: async function(address, spender, amount, tokenAddress) {
        const web3 = new Web3(ethereum)
        console.log(tokenAddress);
        const contract = new web3.eth.Contract(this.abi, tokenAddress)
        try {
            await contract.methods.transferFrom(address, spender, amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    allocation: async function(address, spender, tokenAddress) {
        const web3 = new Web3(ethereum)
        const contract = new web3.eth.Contract(this.abi, tokenAddress)
        try {
            return await contract.methods.allowance(address, spender).call();
        } catch (error) {
            return -1
        }
    }
}

export default ERC20
