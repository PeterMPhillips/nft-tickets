//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import '@opengsn/gsn/conracts/BasePaymaster.sol';
import '@opengsn/gsn/conracts/interfaces/GSNTypes.sol';

contract TicketPaymaster is BasePaymaster{
  mapping(address => bool) private _contracts;

  event RelayFinished(bool success, bytes context);
  event Approve(address indexed contract);
  event Revoke(address indexed contract);

  function versionPaymaster() external view override virtual returns (string memory){
    return 'TicketSalePaymaster_0.0.1';
  }

  function preRelayedCall(
      GsnTypes.RelayRequest calldata relayRequest,
      bytes calldata signature,
      bytes calldata approvalData,
      uint256 maxPossibleGas
    )
    external
    override
    virtual
    returns (bytes memory context, bool revertOnRecipientRevert) {
      (relayRequest, signature, approvalData, maxPossibleGas);
      require(_contracts[relayRequest.request.to], "Paymaster: Contract not in contracts list");
      return ("", false);
    }

  function postRelayedCall(
    bytes calldata context,
    bool success,
    bytes32 preRetVal,
    uint256 gasUseWithoutPost,
    GSNTypes.GasData calldata gasData
  ) external override {
    (preRetVal, gasUseWithoutPost, gasData);
    emit RelayFinished(success, context);
  }

  function approveContract(address contract) external onlyOwner {
    require(!recipients[contract], 'Paymaster: Contract already approved');
    recipients[contract] = true;
    emit Approve(contract);
  }

  function revokeContract(address contract) external onlyOwner {
    require(recipients[contract], 'Paymaster: Contract not currently approved');
    recipients[contract] = false;
    emit Revoke(contract);
  }
}
