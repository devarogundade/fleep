/* contracts */
const PriceApi = artifacts.require("PriceApi");
const FleepSwap = artifacts.require("FleepSwap");
const FleepSweeper = artifacts.require("FleepSweeper");
const FleepToken = artifacts.require("FleepToken");

module.exports = async function(deployer) {
    await deployer.deploy(PriceApi);
    await deployer.deploy(FleepToken);
    await deployer.deploy(FleepSwap, PriceApi.address, FleepToken.address);
    await deployer.deploy(FleepSweeper, FleepSwap.address);
};
