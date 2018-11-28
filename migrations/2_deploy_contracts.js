const Token = artifacts.require("./Token");
const Auction = artifacts.require("./Auction");
const Factory = artifacts.require("./UniswapFactory");

module.exports = function(deployer) {
  const name = "CoStarter";
  const symbol = "Stars";
  const decimals = 18;
  const total = 1000000000000000000000000000;

  const rate = 1400000;
  const wallet = "0x627306090abab3a6e1400e9345bc60c78a8bef57";
  const startTime = 1543228053; // UnixDate change THIS
  const dayWeiMinimum = 10000000000000000000; // change THIS
  const bonus = 400000;

  deployer.deploy(Token, name, symbol, decimals, total).then(async () => {
    await deployer.deploy(Factory);
    const factory = await Factory.at(Factory.address);
    await factory.launchExchange(Token.address);
    const exchangeAddress = await factory.tokenToExchangeLookup(Token.address);
    await deployer.deploy(Auction, rate, wallet, Token.address, startTime, dayWeiMinimum, bonus, exchangeAddress);
  })
};