//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Tickets is ERC721, Ownable {
  uint256 private _counter = 0;

  constructor(string memory name, string memory symbol) ERC721(name, symbol) public {}

  function mint(address to) external onlyOwner returns (uint256){
    uint256 tickerId = _counter;
    _safeMint(to, tickerId);
    _counter += 1;
    return ticketId;
  }
}
