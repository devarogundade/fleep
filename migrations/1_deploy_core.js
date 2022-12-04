/* contracts */
const PriceApi = artifacts.require("PriceApi");
const Swap = artifacts.require("Swap");
const Sweeper = artifacts.require("Sweeper");

module.exports = async function(deployer) {
    await deployer.deploy(PriceApi);
    await deployer.deploy(Swap, PriceApi.address);
    await deployer.deploy(Sweeper, "0x94cD5e6f03d765F3234c3ece3e0Ad22b40e62E39");
};