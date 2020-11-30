//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@opengsn/gsn/contracts/BaseRelayRecipient.sol';
import './interfaces/IDai.sol';
import './interfaces/IToken.sol';
import './Tickets.sol';

contract TicketSale is Ownable, BaseRelayRecipient{
  Tickets private _tickets;
  IDai private _dai;
  uint256 private _price;

  event Purchase(address indexed purchaser, uint256 indexed tickerId);

  constructor(string memory name, string memory symbol, address dai, uint256 price) public {
    _tickets = new Tickets(name, symbol);
    _dai = IDai(dai);
    _price = price;
  }

  // External functions

  function purchaseTicket() public {
    address msgSender = _msgSender();
    _purchaseTicket(msgSender);
  }

  // Since approve and transferFrom are done in an atomic transaction, we can support GSN on this transaction
  function permitAndPurchaseTicket(uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external {
    address msgSender = _msgSender();
    _dai.permit(msgSender, address(this), nonce, expiry, allowed, v, r, s);
    _purchaseTicket(msgSender);
  }

  function price() external view returns (uint256) {
    return _price;
  }

  function withdrawEth() external onlyOwner {
    owner().transfer(address(this).balance);
  }

  function withdrawDai() external onlyOwner {
    uint256 balance = _dai.balanceOf(address(this));
    _dai.transfer(owner(), balance);
  }

  // Just in case
  function withdrawToken(address token) external onlyOwner {
    IToken _token = IToken(token);
    uint256 balance = _token.balanceOf(address(this));
    _token.transfer(owner(), balance);
  }

  // Internal functions

  function _purchaseTicket(address purchaser) internal {
    _dai.transferFrom(purchaser, address(this), price);
    uint256 ticketId = _tickets.mint(purchaser);
    emit Purchase(purchaser, ticketId);
  }

  // BaseRelayRecipient

  function _msgSender() internal override(BaseRelayRecipient, Context) view returns (address payable) {
    return BaseRelayRecipient._msgSender();
  }

  function versionRecipient() external view override virtual returns (string memory){
      return "TicketSale_0.0.1";
  }
}
