/* contracts */
const PriceApi = artifacts.require("PriceApi");
const Swap = artifacts.require("Swap");
const Sweeper = artifacts.require("Sweeper");
const Token = artifacts.require("Token");

module.exports = async function(deployer) {
    // await deployer.deploy(PriceApi);
    // await deployer.deploy(Token);
    await deployer.deploy(Swap, "0xe8953776c2C0f7858Db799bB7d2235CAFe49Dbaa", "0xF27eB9866eF635d1328548F10Ff16b56724E2c69");
    // await deployer.deploy(Sweeper, Swap.address);
};
