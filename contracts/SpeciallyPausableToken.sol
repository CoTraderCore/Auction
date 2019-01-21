pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title SpeciallyPausableToken
 * @dev StandardToken modified with pausable transfers.
 * allow transfer only to specific address
 **/
contract SpeciallyPausableToken is StandardToken, Ownable{

  event Pause();
  event Unpause();

  bool public paused = false;
  // this special address can accept tokens even when paused
  address public specialAddress;

  /**
   * @dev Modifier to make a function callable only when the contract is not paused
   * or only for specific address.
   */
  modifier whenNotPausedOr(address _to) {
    require(!paused || _to == specialAddress);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }

  /**
   * @dev set specialAddress
   */
  function setSpecialAddress(address _specialAddress) public onlyOwner {
    specialAddress = specialAddress;
  }


  // override transfer with specific address

  function transfer(
    address _to,
    uint256 _value
  )
    public
    whenNotPausedOr(_to)
    returns (bool)
  {
    return super.transfer(_to, _value);
  }


  //override other ERC20 functions wth pausable standard

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(
    address _spender,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval(
    address _spender,
    uint _addedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(
    address _spender,
    uint _subtractedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}
