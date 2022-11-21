const HDWalletProvider = require('@truffle/hdwallet-provider')

const dotenv = require("dotenv")
dotenv.config()

const MNEMONIC = process.env.MNEMONIC;
const MATIC_RPC_ID = process.env.MATIC_RPC_ID;

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1", // Ganache
            port: 7545,
            network_id: "*",
        },
        testnet: {
            provider: () => new HDWalletProvider(
                MNEMONIC,
                `https://rpc-mumbai.maticvigil.com/v1/${MATIC_RPC_ID}`
            ),
            network_id: 80001, // Polygon chain testnet id
            confirmations: 2,
            timeoutBlocks: 9999999,
            skipDryRun: true,
            networkCheckTimeout: 999999999
        },
        mainnet: {
            provider: () => new HDWalletProvider(
                MNEMONIC,
                `https://rpc-mumbai.maticvigil.com/v1/${MATIC_RPC_ID}`
            ),
            network_id: 80001, // Polygon chain mainnet id
            confirmations: 2,
            timeoutBlocks: 9999999,
            skipDryRun: true,
            networkCheckTimeout: 999999999
        }
    },

    mocha: {},

    compilers: {
        solc: {
            version: "0.8.16",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 1500
                }
            }
        }
    },

    plugins: ["truffle-contract-size"],
};