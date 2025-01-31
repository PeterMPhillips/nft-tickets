//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import './IToken';

interface IDai is IToken {
  function permit(
    address holder,
    address spender,
    uint256 nonce,
    uint256 expiry,
    bool allowed,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;
}
