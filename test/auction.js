import ether from './helpers/ether';
import EVMRevert from './helpers/EVMRevert';
import {
  increaseTimeTo,
  duration
} from './helpers/increaseTime';
import latestTime from './helpers/latestTime';

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should();

const Token = artifacts.require('Token');
const Auction = artifacts.require('Auction');

contract('Auction', function([_, wallet]) {

  beforeEach(async function() {
    // Token config
    this.name = "CoTrader";
    this.symbol = "COT";
    this.decimals = 18;
    // ether convert 10 000 000 000 COT to 10000000000000000000000000000 hex
    this.totalSupply = ether(1000000000000);

    // Deploy Token
    this.token = await Token.new(
      this.name,
      this.symbol,
      this.decimals,
      this.totalSupply,
    );

    //Crowdsale
    this.rate = 1400000;
    this.wallet = "0x627306090abab3a6e1400e9345bc60c78a8bef57"; // TODO: Replace me
    this.startTime = 1543228053; // UnixDate change THIS
    this.dayWeiMinimum = 10000000000000000000;
    this.daiWeiMaximum = 20000000000000000000;
    this.bonus = 400000;

    //Deploy sale
    this.auction = await Auction.new(
      this.rate,
      this.wallet,
      this.token.address,
      this.startTime,
      this.dayWeiMinimum,
      this.daiWeiMaximum,
      this.bonus
    );
    // Transfer token ownership to dao
    await this.token.transfer(this.auction.address, this.totalSupply);
  });

  describe('INIT Auction with correct values', function() {
    it('Balance 1000000000000', async function() {
      const balance = await this.token.balanceOf(this.auction.address);
      assert.equal(web3.fromWei(balance, 'ether'), web3.fromWei(1000000000000000000000000000000, 'ether'));
    });
  });

  describe('Auction', function() {
    it('buy', async function() {
      await this.auction.sendTransaction({
        value: ether(1),
        from: _
      }).should.be.fulfilled;
    });

    it('buy more minimum auction day', async function() {
      await this.auction.sendTransaction({
        value: ether(1),
        from: _
      }).should.be.fulfilled;

      await this.auction.sendTransaction({
        value: ether(90),
        from: _
      }).should.be.fulfilled;

      await this.auction.sendTransaction({
        value: ether(1),
        from: _
      }).should.be.fulfilled;
    });

  });
});