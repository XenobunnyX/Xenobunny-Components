// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./MailboxClient.sol";
import "../../libraries/ExcessivelySafeCall.sol";
import {TypeCasts} from "../../libraries/TypeCasts.sol";
import {IMessageRecipient} from "../../interfaces/IMessageRecipient.sol";

abstract contract HlApp is MailboxClient, IMessageRecipient {
    using ExcessivelySafeCall for address;

    uint128 public DEFAULT_GAS_LIMIT = 200_000;
    uint128 public DEFAULT_PAYLOAD_LIMIT = 10_000;
    uint256 failedMessagesAmount;

    mapping(uint32 => uint) public minDstGasLookup;
    mapping(uint32 => address) public trustedRemoteLookup;
    mapping(uint32 => uint) public payloadSizeLimitLookup;
    mapping(uint32 => mapping(bytes32 => mapping(uint256 => bytes32)))
        public failedMessages;

    event SetDefaultGasLimit(uint128 _limit);
    event SetMinDstGas(uint32 _dstChainId, uint _minDstGas);
    event SetTrustedRemoteAddress(
        uint32 _remoteChainId,
        address _remoteAddress
    );
    event SetBatchTrustedRemoteAddress(
        uint32[] _remoteChainIds,
        address[] _remoteAddresses
    );
    event DeliverMessage(uint32 _dstChainId, uint256 _value, bytes _message);
    event ReceivedMessage(
        uint32 _srcChainId,
        bytes32 _sender,
        uint256 _value,
        bytes _messag
    );
    event MessageFailed(
        uint32 _srcChainId,
        bytes32 _srcAddress,
        uint256 _nonce,
        bytes _payload,
        bytes _reason
    );
    event RetryMessageSuccess(
        uint32 _srcChainId,
        bytes32 _srcAddress,
        uint256 _nonce,
        bytes32 _payloadHash
    );

    constructor(
        address _owner,
        address _mailbox
    ) MailboxClient(_owner, _mailbox) {}

    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _message
    ) external payable virtual override onlyMailbox {
        address trusedRemote = TypeCasts.bytes32ToAddress(_sender);
        if (
            trustedRemoteLookup[_origin] == address(0) ||
            trusedRemote != trustedRemoteLookup[_origin]
        ) revert InvalidXenoEndpointCaller(trusedRemote);

        _blockingHlReceive(_origin, _sender, _message);
    }

    function nonblockingHlReceive(
        uint32 _srcChainId,
        bytes32 _srcAddress,
        bytes memory _payload
    ) public virtual {
        if (_msgSender() != address(this))
            revert InvalidXenoEndpointCaller(msg.sender);
        _nonblockingHlReceive(_srcChainId, _srcAddress, _payload);
    }

    function retryMessage(
        uint32 _srcChainId,
        bytes32 _srcAddress,
        uint256 _nonce,
        bytes calldata _payload
    ) public payable virtual {
        bytes32 payloadHash = failedMessages[_srcChainId][_srcAddress][_nonce];
        if (payloadHash == bytes32(0)) revert InvalidPayload();
        if (keccak256(_payload) != payloadHash) revert InvalidParams();
        failedMessages[_srcChainId][_srcAddress][_nonce] = bytes32(0);

        _nonblockingHlReceive(_srcChainId, _srcAddress, _payload);
        emit RetryMessageSuccess(_srcChainId, _srcAddress, _nonce, payloadHash);
    }

    //--------------------------- INTERNAL FUNCTIONS ----------------------------------------
    function _hlSend(
        uint32 _dstChainId,
        bytes memory _payload,
        address payable _refundAddress,
        bytes calldata _adapterParams,
        uint _nativeFee
    ) internal {
        address trustedRemote = trustedRemoteLookup[_dstChainId];
        if (trustedRemote == address(0)) revert InvalidDstChain();
        _checkPayloadSize(_dstChainId, _payload.length);

        (uint gasLimit, bytes memory customBytes) = _checkHlAdapterConfig(
            _dstChainId,
            _adapterParams
        );

        uint estimateFee = _quoteDispatch(
            _dstChainId,
            TypeCasts.addressToBytes32(_refundAddress),
            uint256(0),
            gasLimit,
            _payload,
            customBytes
        );

        if (_nativeFee < estimateFee) revert InsufficientFee();

        _dispatch(
            _dstChainId,
            TypeCasts.addressToBytes32(trustedRemote),
            _nativeFee,
            gasLimit,
            _payload,
            customBytes
        );
        emit DeliverMessage(_dstChainId, _nativeFee, _payload);
    }

    //--------------------------- INTERNAL FUNCTION ----------------------------------------
    function _blockingHlReceive(
        uint32 _srcChainId,
        bytes32 _srcAddress,
        bytes memory _payload
    ) internal virtual {
        (bool success, bytes memory reason) = address(this).excessivelySafeCall(
            gasleft(),
            150,
            abi.encodeWithSelector(
                this.nonblockingHlReceive.selector,
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
        uint32 _srcChainId,
        bytes32 _srcAddress,
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

    function _nonblockingHlReceive(
        uint32 _srcChainId,
        bytes32 _srcAddress,
        bytes memory _payload
    ) internal virtual;

    function _checkHlAdapterConfig(
        uint32 _dstChainId,
        bytes calldata _adapterParams
    )
        internal
        view
        virtual
        returns (uint providedGasLimit, bytes memory customBytes)
    {
        providedGasLimit = uint256(bytes32(_adapterParams[0:32]));

        if (32 < _adapterParams.length) {
            customBytes = _adapterParams[32:_adapterParams.length];
        }
        uint minGasLimit = 0 < minDstGasLookup[_dstChainId]
            ? minDstGasLookup[_dstChainId]
            : DEFAULT_GAS_LIMIT;
        if (providedGasLimit < minGasLimit) revert InvalidGasLimit();
    }

    function _checkPayloadSize(
        uint32 _dstChainId,
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
        uint32 _remoteChainId,
        address _remoteAddress
    ) external onlyOwner {
        trustedRemoteLookup[_remoteChainId] = _remoteAddress;

        emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
    }

    function setBatchTrustedRemoteAddress(
        uint32[] memory _remoteChainIds,
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
        uint32 _dstChainId,
        uint _size
    ) external onlyOwner {
        payloadSizeLimitLookup[_dstChainId] = _size;
    }

    function setMinDstGas(uint32 _dstChainId, uint _minGas) external onlyOwner {
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
