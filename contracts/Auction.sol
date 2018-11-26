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
 uint256 public hoursT = 5; //Remove this change to hardcode 24 hours

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


  function calculateRate(uint256 _value)
  internal view returns (uint256)
  {
    require(rate > 1000);

    uint256 totalPercent;
    uint256 onePercent;
    uint256 value;
    uint256 percentFromValue;
    uint256 sumRate;

    totalPercent = weiTodayMaximum.sub(weiTodayMinimum);
    onePercent = totalPercent.div(100);
    value = _value.sub(weiTodayMinimum);
    percentFromValue = value.div(onePercent);
    sumRate = bonus.div(100).mul(percentFromValue);
    return bonus.sub(sumRate);
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
      uint256 r = calculateRate(weiToday.add(weiRaised));
      if (r < 1000){
        return _weiAmount.mul(1000);
      }else{
        return _weiAmount.mul(r);
      }
    }
  }
}
