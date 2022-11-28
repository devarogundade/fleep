import XF from '@xend-finance/web-sdk';
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, collection, getDocs, doc, setDoc, addDoc, getDoc } from "firebase/firestore";

const dotenv = require("dotenv")
dotenv.config()

const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID,
};

const firebaseApp = initializeApp(firebaseConfig);
const analytics = getAnalytics(firebaseApp);
const COLLECTION = "users"

const FleepVault = {
    instance: null,
    db: getFirestore(firebaseApp),
    getInstance: async function(network = false) {
        if (this.instance != null) return this.instance

        try {
            const config = network ? { chainId: 137, env: 'mainnet' } : { chainId: 8002, env: 'testnet' }
            this.instance = await XF(config.chainId, PRIVATE_KEY, { env: config.env });
            return this.instance
        } catch (error) {
            return null
        }
    },
    createWallet: async function(address) {
        const instance = await this.getInstance()

        if (instance == null) return {
            status: false,
            error: null,
            message: 'Failed to initialize'
        }

        try {
            const wallet = await instance.createWallet()

            // write to fireStore
            const reference = doc(this.db, COLLECTION, address)
            await setDoc(reference, {
                address: address,
                phrase: ''
            })

            return {
                status: this,
                wallet: wallet,
                message: 'Failed'
            }
        } catch (error) {
            return {
                status: false,
                error: error,
                message: 'Failed'
            }
        }
    },
    deposit: async function(amount) {
        const instance = await this.getInstance()

        if (instance == null) {
            return {

            }
        }

        try {
            const response = await instance.flexibleDeposit(amount);
            return response;
        } catch (error) {
            return {

            }
        }

    }
}

export default FleepVault
