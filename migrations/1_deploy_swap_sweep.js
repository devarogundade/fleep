/* contracts */
const PriceApi = artifacts.require("PriceApi");
const Swap = artifacts.require("Swap");
const Sweeper = artifacts.require("Sweeper");

module.exports = async function(deployer) {
    // await deployer.deploy(PriceApi);
    await deployer.deploy(Swap, "0xe8953776c2C0f7858Db799bB7d2235CAFe49Dbaa");
    await deployer.deploy(Sweeper, Swap.address);
};