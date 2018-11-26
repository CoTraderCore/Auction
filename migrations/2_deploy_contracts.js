const Token = artifacts.require("./Token");
const Auction = artifacts.require("./Auction");

module.exports = function(deployer) {
  const name = "Token";
  const symbol = "TKN";
  const decimals = 18;
  const total = 10000000000000000000000000;

  const rate = 1400000;
  const wallet = "0x627306090abab3a6e1400e9345bc60c78a8bef57";
  const startTime = 1543228053; // UnixDate change THIS
  const dayWeiMinimum = 10000000000000000000; // change THIS
  const daiWeiMaximum = 20000000000000000000; // change THIS
  const bonus = 400000;

  deployer.deploy(Token, name, symbol, decimals, total)
    .then(() => {
      return deployer.deploy(Auction, rate, wallet, Token.address, startTime, dayWeiMinimum, daiWeiMaximum, bonus);
    })
};