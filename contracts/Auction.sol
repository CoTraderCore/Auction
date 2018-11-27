pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Auction is Crowdsale, Ownable{

 using SafeMath for uint256;

 uint256 public startTime;
 uint256 public previosWei;
 uint256 public nextTime;
 uint256 public weiTodayMinimum;
 uint256 public weiTodayMaximum;
 uint256 public bonus;
 uint256 public hoursT = 5 minutes; //Remove this change to hardcode 24 hours
 mapping (address => uint256) private usersETH;

 constructor(
    uint256 _rate,
    address _wallet,
    ERC20 _token,
    uint256 _startTime,
    uint256 _weiDayMinimum,
    uint256 _weiTodayMaximum,
    uint256 _bonus
  )
  Crowdsale(_rate, _wallet, _token)
  public
  {
    startTime = _startTime;
    nextTime = _startTime.add(hoursT);
    weiTodayMinimum = _weiDayMinimum;
    weiTodayMaximum = _weiTodayMaximum;
    bonus = _bonus;
  }

  function updateDayAuction() private
  {
    require(block.timestamp >= nextTime);
    startTime.add(24 hours);
    nextTime = startTime.add(hoursT);
    previosWei = weiRaised;
  }

  function returnTodayWei()
  internal view returns (uint256)
  {
    return weiRaised.sub(previosWei);
  }

  function returnUserETHByAddress()
  public view returns (uint256)
  {
    return usersETH[msg.sender];
  }

  // Write user ETH value to mapping
  function _postValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    usersETH[_beneficiary] = _weiAmount;
  }

  // Owirride rate count
  function _getTokenAmount(uint256 _weiAmount)
    internal view returns (uint256)
  {

    if(block.timestamp >= nextTime){
      updateDayAuction();
    }

    uint256 weiToday = returnTodayWei();

    if (weiToday < weiTodayMinimum){
      return _weiAmount.mul(rate);
    }
    else{
      return _weiAmount.mul(rate.div(2));
    }
  }
}
