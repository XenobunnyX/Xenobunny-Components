// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../../interfaces/IXenoSystem.sol";
import "../../libraries/XenoAppErrors.sol";
import "../../libraries/ExcessivelySafeCall.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {VizingOmni} from "@vizing/contracts/VizingOmni.sol";

abstract contract VoApp is VizingOmni, Ownable {
    //---------------------------  LIBRARIES  ----------------------------------------
    using ExcessivelySafeCall for address;

    //---------------------------  STATE VARIABLES  ----------------------------------------
    uint128 public DEFAULT_GAS_LIMIT = 200_000;
    uint128 public DEFAULT_PAYLOAD_LIMIT = 10_000;
    address public DEFAULT_RELAYER = address(0);
    uint256 failedMessagesAmount;

    mapping(uint64 => uint) public minDstGasLookup;
    mapping(uint64 => address) public trustedRemoteLookup;
    mapping(uint64 => uint) public payloadSizeLimitLookup;
    mapping(uint64 => mapping(address => mapping(uint256 => bytes32)))
        public failedMessages;

    //--------------------------- EVENTS ----------------------------------------
    event SetDefaultGasLimit(uint128 _limit);
    event SetDefaultRelayer(address _relayer);
    event SetMinDstGas(uint64 _dstChainId, uint _minDstGas);
    event SetTrustedRemoteAddress(
        uint64 _remoteChainId,
        address _remoteAddress
    );
    event SetBatchTrustedRemoteAddress(
        uint64[] _remoteChainIds,
        address[] _remoteAddresses
    );
    event DeliverMessage(uint64 _dstChainId, uint256 _value, bytes _message);
    event ReceivedMessage(
        uint64 _srcChainId,
        address _sender,
        uint256 _value,
        bytes _messag
    );
    event MessageFailed(
        uint64 _srcChainId,
        address _srcAddress,
        uint256 _nonce,
        bytes _payload,
        bytes _reason
    );
    event RetryMessageSuccess(
        uint64 _srcChainId,
        address _srcAddress,
        uint256 _nonce,
        bytes32 _payloadHash
    );

    //--------------------------- CONSTRUCTOR ----------------------------------------
    constructor(
        address _vizingEndpoint,
        address _owner
    ) VizingOmni(_vizingEndpoint) Ownable(_owner) {}

    //--------------------------- RELAYER RELATED ----------------------------------------
    function _receiveMessage(
        uint64 _srcChainId,
        uint256 _srcContract,
        bytes calldata _message
    ) internal virtual override {
        address trusedRemote = address(uint160(_srcContract));
        if (
            trustedRemoteLookup[_srcChainId] == address(0) ||
            trusedRemote != trustedRemoteLookup[_srcChainId]
        ) revert InvalidXenoEndpointCaller(trusedRemote);

        _blockingVoReceive(_srcChainId, trusedRemote, _message);
    }

    function nonblockingVoReceive(
        uint64 _srcChainId,
        address _srcAddress,
        bytes memory _payload
    ) public payable virtual {
        if (_msgSender() != address(this))
            revert InvalidXenoEndpointCaller(msg.sender);
        _nonblockingVoReceive(_srcChainId, _srcAddress, _payload);
    }

    function retryMessage(
        uint64 _srcChainId,
        address _srcAddress,
        uint256 _nonce,
        bytes calldata _payload
    ) public payable virtual {
        bytes32 payloadHash = failedMessages[_srcChainId][_srcAddress][_nonce];
        if (payloadHash == bytes32(0)) revert InvalidPayload();
        if (keccak256(_payload) != payloadHash) revert InvalidParams();
        failedMessages[_srcChainId][_srcAddress][_nonce] = bytes32(0);

        _nonblockingVoReceive(_srcChainId, _srcAddress, _payload);
        emit RetryMessageSuccess(_srcChainId, _srcAddress, _nonce, payloadHash);
    }

    //--------------------------- INTERNAL FUNCTIONS ----------------------------------------
    function _voSend(
        uint64 _dstChainId,
        bytes memory _payload,
        address payable /* _refundAddress */,
        bytes calldata _adapterParams,
        uint _nativeFee
    ) internal {
        address trustedRemote = trustedRemoteLookup[_dstChainId];
        if (trustedRemote == address(0)) revert InvalidDstChain();
        _checkPayloadSize(_dstChainId, _payload.length);

        (
            uint transferValue,
            uint gasLimit,
            uint gasPrice,
            bytes memory customBytes
        ) = _checkVoAdapterConfig(_dstChainId, _adapterParams);
        uint64 _sDstChainId = _dstChainId; /// avoid stack too deep
        bytes memory _sPayload = _payload; /// avoid stack too deep
        bytes memory encodedMessage = _packetMessage(
            bytes1(0x01),
            trustedRemote,
            uint24(gasLimit),
            uint64(gasPrice),
            _sPayload
        );

        uint estimateFee = _estimateVizingGasFee(
            transferValue,
            _sDstChainId,
            customBytes,
            _sPayload
        );

        if (_nativeFee < estimateFee + transferValue) revert InsufficientFee();

        LaunchPad.Launch{value: msg.value}(
            0,
            0,
            DEFAULT_RELAYER,
            _msgSender(),
            transferValue,
            _sDstChainId,
            customBytes,
            encodedMessage
        );

        emit DeliverMessage(_sDstChainId, _nativeFee, _sPayload);
    }

    //--------------------------- INTERNAL FUNCTION ----------------------------------------
    function _blockingVoReceive(
        uint64 _srcChainId,
        address _srcAddress,
        bytes memory _payload
    ) internal virtual {
        if (0 < msg.value) {
            (bytes memory toAddressBytes, , ) = abi.decode(
                _payload,
                (bytes, uint256, uint256)
            );

            address toAddress;
            assembly {
                toAddress := mload(add(toAddressBytes, 20))
            }
            payable(toAddress).transfer(msg.value);
        }
        (bool success, bytes memory reason) = address(this).excessivelySafeCall(
            gasleft(),
            150,
            abi.encodeWithSelector(
                this.nonblockingVoReceive.selector,
                _srcChainId,
                _srcAddress,
                _payload
            )
        );
        // try-catch all errors/exceptions
        if (!success) {
            _storeFailedMessage(_srcChainId, _srcAddress, _payload, reason);
        } else {
            emit ReceivedMessage(_srcChainId, _srcAddress, msg.value, _payload);
        }
    }

    function _storeFailedMessage(
        uint64 _srcChainId,
        address _srcAddress,
        bytes memory _payload,
        bytes memory _reason
    ) internal virtual {
        failedMessagesAmount++;
        failedMessages[_srcChainId][_srcAddress][
            failedMessagesAmount
        ] = keccak256(_payload);

        emit MessageFailed(
            _srcChainId,
            _srcAddress,
            failedMessagesAmount,
            _payload,
            _reason
        );
    }

    /// @notice need override
    function _nonblockingVoReceive(
        uint64 _srcChainId,
        address _srcAddress,
        bytes memory _payload
    ) internal virtual;

    function _checkVoAdapterConfig(
        uint64 _dstChainId,
        bytes calldata _adapterParams
    )
        internal
        view
        virtual
        returns (
            uint transferValue,
            uint providedGasLimit,
            uint providedGasPrice,
            bytes memory customBytes
        )
    {
        transferValue = uint256(bytes32(_adapterParams[0:32]));
        if (32 < _adapterParams.length) {
            providedGasLimit = uint256(bytes32(_adapterParams[32:64]));
        }
        if (64 < _adapterParams.length) {
            providedGasPrice = uint256(bytes32(_adapterParams[64:96]));
        }
        if (96 < _adapterParams.length) {
            customBytes = _adapterParams[96:_adapterParams.length];
        }
        uint minGasLimit_ = 0 < minDstGasLookup[_dstChainId]
            ? minDstGasLookup[_dstChainId]
            : DEFAULT_GAS_LIMIT;
        if (providedGasLimit < minGasLimit_) revert InvalidGasLimit();
    }

    function _checkPayloadSize(
        uint64 _dstChainId,
        uint _payloadSize
    ) internal view virtual {
        uint payloadSizeLimit = payloadSizeLimitLookup[_dstChainId];
        if (payloadSizeLimit == 0) {
            payloadSizeLimit = DEFAULT_PAYLOAD_LIMIT;
        }
        if (payloadSizeLimit < _payloadSize) revert InvalidPayload();
    }

    //--------------------------- APPLICATION CONFIG ----------------------------------------
    function setTrustedRemoteAddress(
        uint64 _remoteChainId,
        address _remoteAddress
    ) external onlyOwner {
        trustedRemoteLookup[_remoteChainId] = _remoteAddress;

        emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
    }

    function setBatchTrustedRemoteAddress(
        uint64[] memory _remoteChainIds,
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
        uint64 _dstChainId,
        uint _size
    ) external onlyOwner {
        payloadSizeLimitLookup[_dstChainId] = _size;
    }

    function setMinDstGas(uint64 _dstChainId, uint _minGas) external onlyOwner {
        minDstGasLookup[_dstChainId] = _minGas;
        emit SetMinDstGas(_dstChainId, _minGas);
    }

    function setDefaultGasLimit(uint128 _limit) external onlyOwner {
        DEFAULT_GAS_LIMIT = _limit;

        emit SetDefaultGasLimit(_limit);
    }

    function setDefaultRelayer(address _relayer) external onlyOwner {
        DEFAULT_RELAYER = _relayer;

        emit SetDefaultRelayer(_relayer);
    }

    //--------------------------- VIZING FUNCTIONS ----------------------------------------
    function minArrivalTime() external view virtual override returns (uint64) {
        return 0;
    }

    function maxArrivalTime() external view virtual override returns (uint64) {
        return 0;
    }

    function minGasLimit() external view virtual override returns (uint24) {
        return uint24(DEFAULT_GAS_LIMIT);
    }

    function maxGasLimit() external view virtual override returns (uint24) {
        return uint24(DEFAULT_GAS_LIMIT);
    }

    function defaultBridgeMode()
        external
        view
        virtual
        override
        returns (bytes1)
    {
        return bytes1(0x01);
    }

    function selectedRelayer()
        external
        view
        virtual
        override
        returns (address)
    {
        return DEFAULT_RELAYER;
    }

    //--------------------------- VIEW FUNCTIONS ----------------------------------------
    function isTrustedRemote(
        uint64 _remoteChain,
        address _remoteAddress
    ) external view returns (bool) {
        return trustedRemoteLookup[_remoteChain] == _remoteAddress;
    }

    function getTrustedRemoteAddress(
        uint64 _remoteChain
    ) public view returns (address) {
        return trustedRemoteLookup[_remoteChain];
    }
}
