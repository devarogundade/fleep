/* contracts */
const FleepToken = artifacts.require("FleepToken");

module.exports = async function(deployer) {
    await deployer.deploy(FleepToken);
};