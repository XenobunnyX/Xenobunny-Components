// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IXenoTravel {
   function travel(
        address _sender,
        uint16 _dstChainId,
        bytes memory _payload,
        bytes memory _adapterParams
    ) external payable;

     function estimateSendFee(
        uint16 _dstChainId,
        bytes memory _payload,
        bytes memory _adapterParams
    ) external view returns (uint256 nativeFee, uint256 zroFee);
}
