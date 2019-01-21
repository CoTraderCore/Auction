const Token = artifacts.require("./Token");
const Auction = artifacts.require("./Auction");
const Factory = artifacts.require("./UniswapFactoryInterface");
const Exchange = artifacts.require("./UniswapExchangeInterface");

module.exports = function(deployer) {
  const name = "CoStarter";
  const symbol = "Stars";
  const decimals = 18;
  const total = 1000000000000000000000000000;

  const rate = 1400000;
  const wallet = "0x627306090abab3a6e1400e9345bc60c78a8bef57";
  const startTime = 1543487203; // UnixDate change THIS
  const dayWeiMinimum = 10000000000000000000; // change THIS
  const bonus = 400000;
  const owner = "0x627306090abab3a6e1400e9345bc60c78a8bef57" // change me
  const FactoryRinkebyAddress = "0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36";
  const MainNetAddress = "0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95";

  deployer.deploy(Token, name, symbol, decimals, total).then(async () => {
    const factory = await Factory.at(FactoryRinkebyAddress);
    // pass token and owner exchange address
    await factory.launchExchange(Token.address, owner);
    // pass Exchange address as ICO wallet
    const exchangeAddress = await factory.tokenToExchangeLookup(Token.address);
    await deployer.deploy(Auction, rate, exchangeAddress, Token.address, startTime, dayWeiMinimum, bonus);
  })
};
