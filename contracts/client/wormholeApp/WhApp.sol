// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../libraries/XenoAppErrors.sol";
import "../../interfaces/IWormholeRelayer.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract WhApp is Ownable {
    IWormholeRelayer public immutable whEndpoint;
    uint128 public DEFAULT_GAS_LIMIT = 300_000;
    uint128 public DEFAULT_PAYLOAD_LIMIT = 10_000;

    mapping(uint16 => uint) public minDstGasLookup;
    mapping(uint16 => address) public trustedRemoteLookup;
    mapping(uint16 => uint) public payloadSizeLimitLookup;

    event SetDefaultGasLimit(uint128 _limit);
    event SetMinDstGas(uint16 _dstChainId, uint _minDstGas);
    event SetTrustedRemoteAddress(
        uint16 _remoteChainId,
        address _remoteAddress
    );
    event SetBatchTrustedRemoteAddress(
        uint16[] _remoteChainIds,
        address[] _remoteAddresses
    );

    constructor(address _whEndpoint) {
        whEndpoint = IWormholeRelayer(_whEndpoint);
    }

    //--------------------------- INTERNAL FUNCTIONS ----------------------------------------
    function _whEvmSend(
        uint16 _dstChainId,
        bytes memory _payload,
        address payable _refundAddress,
        bytes memory _adapterParams,
        uint _nativeFee
    ) internal virtual {
        address trustedRemote = trustedRemoteLookup[_dstChainId];
        if (trustedRemote == address(0)) revert InvalidDstChain();
        _checkPayloadSize(_dstChainId, _payload.length);

        uint16 _dst = _dstChainId;
        address _refund = _refundAddress;

        (uint gasLimit, uint value) = _checkWhAdapterConfig(
            _dst,
            _adapterParams
        );

        (uint256 estimateFee, ) = whEndpoint.quoteEVMDeliveryPrice(
            _dst,
            value,
            gasLimit
        );

        if (_nativeFee < estimateFee) revert InsufficientFee();

        whEndpoint.sendPayloadToEvm{value: estimateFee}(
            _dst,
            trustedRemote,
            _payload,
            value,
            gasLimit,
            _dst,
            _refund
        );
    }

    function _checkWhAdapterConfig(
        uint16 _dstChainId,
        bytes memory _adapterParams
    ) internal view virtual returns (uint providedGasLimit, uint value) {
        (providedGasLimit, value) = abi.decode(
            _adapterParams,
            (uint256, uint256)
        );
        uint minGasLimit = minDstGasLookup[_dstChainId] > 0
            ? minDstGasLookup[_dstChainId]
            : DEFAULT_GAS_LIMIT;
        if (providedGasLimit < minGasLimit) revert InvalidGasLimit();
    }

    function _checkPayloadSize(
        uint16 _dstChainId,
        uint _payloadSize
    ) internal view virtual {
        uint payloadSizeLimit = payloadSizeLimitLookup[_dstChainId];
        if (payloadSizeLimit == 0) {
            payloadSizeLimit = DEFAULT_PAYLOAD_LIMIT;
        }
        if (_payloadSize > payloadSizeLimit) revert InvalidPayload();
    }

    //--------------------------- APPLICATION CONFIG ----------------------------------------

    function setTrustedRemoteAddress(
        uint16 _remoteChainId,
        address _remoteAddress
    ) external onlyOwner {
        trustedRemoteLookup[_remoteChainId] = _remoteAddress;

        emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
    }

    function setBatchTrustedRemoteAddress(
        uint16[] memory _remoteChainIds,
        address[] memory _remoteAddresses
    ) external onlyOwner {
        if (_remoteChainIds.length != _remoteAddresses.length)
            revert InvalidParams();
        for (uint i = 0; i < _remoteChainIds.length; i++) {
            trustedRemoteLookup[_remoteChainIds[i]] = _remoteAddresses[i];
        }
        emit SetBatchTrustedRemoteAddress(_remoteChainIds, _remoteAddresses);
    }

    function setPayloadSizeLimit(
        uint16 _dstChainId,
        uint _size
    ) external onlyOwner {
        payloadSizeLimitLookup[_dstChainId] = _size;
    }

    function setMinDstGas(uint16 _dstChainId, uint _minGas) external onlyOwner {
        minDstGasLookup[_dstChainId] = _minGas;
        emit SetMinDstGas(_dstChainId, _minGas);
    }

    function setDefaultGasLimit(uint128 _limit) external onlyOwner {
        DEFAULT_GAS_LIMIT = _limit;

        emit SetDefaultGasLimit(_limit);
    }
    //--------------------------- VIEW FUNCTIONS ----------------------------------------
    function isTrustedRemote(
        uint16 _remoteChain,
        address _remoteAddress
    ) external view returns (bool) {
        return trustedRemoteLookup[_remoteChain] == _remoteAddress;
    }

    function getTrustedRemoteAddress(
        uint16 _remoteChain
    ) public view returns (address) {
        return trustedRemoteLookup[_remoteChain];
    }
}
