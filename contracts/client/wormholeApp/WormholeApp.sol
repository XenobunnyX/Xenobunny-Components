// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WhApp.sol";
import "../../interfaces/IXenoTravel.sol";
import "../../interfaces/IXenoSystem.sol";
import "../../interfaces/IWormholeReceiver.sol";

contract WormholeApp is IXenoTravel, IWormholeReceiver, WhApp {
    IXenoSystem public xenoBunny;

    constructor(
        address _initOwner,
        address _whEndpoint,
        address _xenoAddress
    ) Ownable(_initOwner) WhApp(_whEndpoint) {
        xenoBunny = IXenoSystem(_xenoAddress);
    }

    /**
     * @dev Mutate NFT (transfer to another blockchain)
     * @param _sender origin caller
     * @param _dstChainId the layerzeron chainId of the target chain
     * @param _payload the receviver and tokenId encoded
     * @param _adapterParams external config
     */
    function travel(
        address _sender,
        uint16 _dstChainId,
        bytes memory _payload,
        bytes memory _adapterParams
    ) external payable {
        if (_msgSender() != address(xenoBunny))
            revert InvalidEndpointCaller(_msgSender());
        if (_adapterParams.length < 32) revert InvalidAdapterParams();

        _whEvmSend(
            _dstChainId,
            _payload,
            payable(_sender),
            _adapterParams,
            msg.value
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
        bytes32 _srcAddress,
        uint16 _srcChainId,
        bytes32
    ) external payable {
        if (_msgSender() != address(whEndpoint))
            revert InvalidEndpointCaller(_msgSender());
        address trusedRemote = address(uint160(uint256(_srcAddress)));
        if (
            trustedRemoteLookup[_srcChainId] == address(0) ||
            trusedRemote != trustedRemoteLookup[_srcChainId]
        ) revert InvalidXenoEndpointCaller(trusedRemote);

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

    //--------------------------- SETTING FUNCTION ----------------------------------------
    /**
     * @dev setting up xenobunny address
     */
    function setXeno(address _xeno) external onlyOwner {
        xenoBunny = IXenoSystem(_xeno);
    }

    /**
     * @dev withdrawal fees
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
        uint256 gasLimit = minDstGasLookup[_dstChainId] > 0
            ? minDstGasLookup[_dstChainId]
            : DEFAULT_GAS_LIMIT;
        return whEndpoint.quoteEVMDeliveryPrice(_dstChainId, value, gasLimit);
    }
}
