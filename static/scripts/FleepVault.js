import XF from '@xend-finance/web-sdk';
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, doc, setDoc, getDoc } from "firebase/firestore";

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
const PRIVATE_KEY = process.env.PRIVATE_KEY

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
    getOrCreatePhrase: async function(address) {
        try {
            const fReference = doc(this.db, COLLECTION, address.toLowerCase());
            const _data = await getDoc(fReference);

            if (_data.exists()) {
                return {
                    status: true,
                    address: _data.data().address,
                    privateKey: _data.data().privateKey
                }
            }

            const instance = await this.getInstance()

            if (instance == null) return {
                status: false,
                error: null
            }

            const wallet = await instance.createWallet()

            // write to fireStore
            const wReference = doc(this.db, COLLECTION, address.toLowerCase())
            const data = {
                address: wallet.address.toLowerCase(),
                privateKey: wallet.privateKey
            }
            await setDoc(wReference, data)

            return {
                status: true,
                phrase: ''
            }
        } catch (error) {
            return {
                status: false,
                error: error
            }
        }
    },
    deposit: async function(privateKey, amount, network = false) {
        try {
            const config = network ? { chainId: 137, env: 'mainnet' } : { chainId: 8002, env: 'testnet' }
            const { xAuto } = await XF(config.chainId, privateKey, { env: config.env });

            const approval = await xAuto.approve("MATIC", amount);

            if (!approval || !approval.status) return {
                status: false
            }

            const response = await xAuto.deposit("MATIC", amount);
            console.log(response);
            return {
                status: true,
                deposit: ''
            };
        } catch (error) {
            return {
                status: false,
                error: error
            }
        }
    }
}

export default FleepVault
