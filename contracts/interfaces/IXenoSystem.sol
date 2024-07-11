// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IXenoSystem {
    function receiveProcesser( uint16 _srcChainId, bytes memory _payload) external;
}