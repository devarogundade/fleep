/* contracts */
const WBTC = artifacts.require("TestnetToken");
const DAI = artifacts.require("TestnetToken");
const WETH = artifacts.require("TestnetToken");
const SAND = artifacts.require("TestnetToken");
const USDC = artifacts.require("TestnetToken");
const USDT = artifacts.require("TestnetToken");

module.exports = async function(deployer) {
    await deployer.deploy(WBTC, "Bitcoin", "WBTC");
    await deployer.deploy(DAI, "DAI", "DAI");
    await deployer.deploy(WETH, "Wrapper Ethereum", "WETH");
    await deployer.deploy(SAND, "Sandbox", "SAND");
    await deployer.deploy(USDC, "USDC", "USDC");
    await deployer.deploy(USDT, "USDT", "USDT");
};