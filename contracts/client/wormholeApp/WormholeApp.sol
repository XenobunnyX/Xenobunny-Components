// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/IXenoTravel.sol";
import "../../interfaces/IXenoSystem.sol";
import "../../interfaces/IWormholeRelayer.sol";
import "../../interfaces/IWormholeReceiver.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NotSupport();
error NotAuthorized();
error InsufficientFee();
error InvalidParams();

contract WormholeApp is IXenoTravel, Ownable, IWormholeReceiver {
    IWormholeRelayer immutable wormholeRelayer;
    IXenoSystem xenoBunny;
    uint32 public GAS_LIMIT = 300_000;

    mapping(uint16 => address) _trustedEndpoint;

    event SetTrustedRemoteAddress(
        uint16 _remoteChainId,
        address _remoteAddress
    );

    event SetBatchTrustedRemoteAddress(
        uint16[] _remoteChainId,
        address[] _remoteAddress
    );

    event SetGasLimit(uint32 _limit);

    constructor(
        address _initOwner,
        address _relayerAddress,
        address _xenoAddress
    ) Ownable(_initOwner) {
        wormholeRelayer = IWormholeRelayer(_relayerAddress);
        xenoBunny = IXenoSystem(_xenoAddress);
    }

    /**
     * @dev Mutate NFT (transfer to another blockchain)
     * @param _sender origin caller
     * @param _dstChainId the layerzeron chainId of the target chain
     * @param _payload the receviver and tokenId encoded
     */
    function travel(
        address _sender,
        uint16 _dstChainId,
        bytes memory _payload,
        bytes memory _adapterParams
    ) external payable {
        if (msg.sender != address(xenoBunny)) revert NotAuthorized();
        if (_trustedEndpoint[_dstChainId] == address(0)) revert NotSupport();
        uint256 value = abi.decode(_adapterParams, (uint256));
        (uint256 estimateFee, ) = wormholeRelayer.quoteEVMDeliveryPrice(
            _dstChainId,
            value,
            GAS_LIMIT
        );

        if (msg.value < estimateFee) revert InsufficientFee();
        wormholeRelayer.sendPayloadToEvm{value: estimateFee}(
            _dstChainId,
            _trustedEndpoint[_dstChainId],
            _payload,
            value,
            GAS_LIMIT,
            _dstChainId,
            _sender
        );
    }

    /**
     * @dev handles receiving NFTs that cross over from other chains
     * @param _payload toAddress, tokenId, variation co-encoded value
     * @param _srcChainId nft source chain id
     */
    function receiveWormholeMessages(
        bytes memory _payload,
        bytes[] memory,
        bytes32,
        uint16 _srcChainId,
        bytes32
    ) external payable {
        if (msg.sender != address(wormholeRelayer)) revert NotAuthorized();
        if (msg.value > 0) {
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
        xenoBunny.receiveProcesser(_srcChainId, _payload);
    }

    /**
     * @dev set trusted endpoint on target blockchain
     * @param _remoteChainId target blockchain id
     * @param _remoteAddress enpdpoint address on target blockchain
     */
    function setTrustedRemoteAddress(
        uint16 _remoteChainId,
        address _remoteAddress
    ) external onlyOwner {
        _trustedEndpoint[_remoteChainId] = _remoteAddress;

        emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
    }

    /**
     * @dev set batch trusted endpoint on target blockchain
     */
    function setBatchTrustedRemoteAddress(
        uint16[] memory _remoteChainIds,
        address[] memory _remoteAddresses
    ) external onlyOwner {
        if (_remoteChainIds.length != _remoteAddresses.length)
            revert InvalidParams();
        for (uint i = 0; i < _remoteChainIds.length; i++) {
            _trustedEndpoint[_remoteChainIds[i]] = _remoteAddresses[i];
        }
        emit SetBatchTrustedRemoteAddress(_remoteChainIds, _remoteAddresses);
    }

    /**
     * @dev setting up xenobunny address
     */
    function setXeno(address _xeno) external onlyOwner {
        xenoBunny = IXenoSystem(_xeno);
    }

    /**
     * @dev setting up gas limit
     */
    function setGasLimit(uint32 _limit) external onlyOwner {
        GAS_LIMIT = _limit;

        emit SetGasLimit(_limit);
    }

    /**
     * @dev withdrawal fees
     * @param receiver fee recipient
     */
    function withdrawByAdmin(address receiver) external onlyOwner {
        payable(receiver).transfer(address(this).balance);
    }

    //--------------------------- VIEW FUNCTION ----------------------------------------
    /**
     * @dev get the fees needed to launch a cross-chain transaction using layerzero
     */
    function estimateSendFee(
        uint16 _dstChainId,
        bytes memory,
        bytes memory _adapterParams
    ) public view returns (uint256 nativeFee, uint256 zroFee) {
        uint256 value = abi.decode(_adapterParams, (uint256));
        return
            wormholeRelayer.quoteEVMDeliveryPrice(
                _dstChainId,
                value,
                GAS_LIMIT
            );
    }

    /**
     * @dev determine the address of the target blockchain's app
     */
    function isTrustedRemote(
        uint16 _remoteChain,
        address _remoteAddress
    ) external view returns (bool) {
        return _trustedEndpoint[_remoteChain] == _remoteAddress;
    }
}
