const HDWalletProvider = require('@truffle/hdwallet-provider')

const dotenv = require("dotenv")
dotenv.config()

const MNEMONIC = process.env.MNEMONIC;
const ALCHEMY_TESTNET_KEY = process.env.ALCHEMY_TESTNET_KEY;
const ALCHEMY_MAINNET_KEY = process.env.ALCHEMY_MAINNET_KEY;

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
                `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_TESTNET_KEY}`
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
                `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_MAINNET_KEY}`
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