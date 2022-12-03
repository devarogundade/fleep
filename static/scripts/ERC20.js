import Web3 from "web3"
import testnetContractJson from "~/build/testnet/TestnetToken.json"
import mainnetContractJson from "~/build/mainnet/TestnetToken.json"
import Network from "./Network"

const ERC20 = {
    network: Network.current() == 'true',
    getAbi: function() { return this.network ? mainnetContractJson.abi : testnetContractJson.abi },
    faucet: async function(address, amount, tokenAddress) {
        const web3 = new Web3(ethereum)
        const contract = new web3.eth.Contract(this.getAbi(), tokenAddress)
        try {
            await contract.methods.faucet(address, amount).send({ from: address })
            return true
        } catch (error) {
            return false
        }
    },
    approve: async function(address, spender, amount, tokenAddress) {
        const web3 = new Web3(ethereum)
        const contract = new web3.eth.Contract(this.getAbi(), tokenAddress)
        try {
            await contract.methods.approve(spender, amount).send({ from: address })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    allocation: async function(address, spender, tokenAddress) {
        const web3 = new Web3(ethereum)
        const contract = new web3.eth.Contract(this.getAbi(), tokenAddress)
        try {
            return await contract.methods.allowance(address, spender).call();
        } catch (error) {
            return 0
        }
    }
}

export default ERC20