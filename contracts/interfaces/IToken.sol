//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

interface IToken {
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
