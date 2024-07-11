// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./NonblockingLzApp.sol";
import "../../interfaces/IXenoSystem.sol";
import "../../interfaces/IXenoTravel.sol";

error NotAuthorized();
error InvalidParams();

contract LayerzeroApp is NonblockingLzApp, IXenoTravel {
    IXenoSystem xenoBunny;
    uint16 public constant FUNCTION_TYPE_SEND = 1;

    mapping(uint16 => uint256) public _dstChainIdToTransferGas;

    event SetBatchTrustedRemoteAddress(
        uint16[] _remoteChainId,
        bytes[] _remoteAddress
    );

    constructor(
        address _initOwner,
        address _lzEndpoint,
        address _xenoAddress
    ) NonblockingLzApp(_lzEndpoint) Ownable(_initOwner) {
        xenoBunny = IXenoSystem(_xenoAddress);
    }

    /**
     * @dev Mutate NFT (transfer to another blockchain)
     * @param _sender origin caller
     * @param _dstChainId the layerzeron chainId of the target chain
     * @param _payload the receviver and tokenId encoded
     * @param _adapterParams layerzero params
     */
    function travel(
        address _sender,
        uint16 _dstChainId,
        bytes memory _payload,
        bytes memory _adapterParams
    ) external payable {
        if (msg.sender != address(xenoBunny)) revert NotAuthorized();
        _checkGasLimit(
            _dstChainId,
            FUNCTION_TYPE_SEND,
            _adapterParams,
            _dstChainIdToTransferGas[_dstChainId]
        );
        _lzSend(
            _dstChainId,
            _payload,
            payable(_sender),
            address(0),
            _adapterParams,
            msg.value
        );
    }

    //--------------------------- SETTING FUNCTION ----------------------------------------
    /**
     * @dev for test
     */
    function setXeno(address _xeno) external onlyOwner {
        xenoBunny = IXenoSystem(_xeno);
    }

    /**
     * @dev setting up layerzero cross-chain gas
     * @param _dstChainId target chain id
     * @param _dstChainIdTransferGas gas amount
     */
    function setDstChainIdToTransferGas(
        uint16 _dstChainId,
        uint256 _dstChainIdTransferGas
    ) external onlyOwner {
        assert(_dstChainIdTransferGas > 0);
        _dstChainIdToTransferGas[_dstChainId] = _dstChainIdTransferGas;
    }

    function setBatchTrustedRemoteAddress(
        uint16[] memory _remoteChainIds,
        bytes[] calldata _remoteAddresses
    ) external onlyOwner {
        if (_remoteChainIds.length != _remoteAddresses.length)
            revert InvalidParams();
        for (uint i = 0; i < _remoteChainIds.length; i++) {
            trustedRemoteLookup[_remoteChainIds[i]] = abi.encodePacked(
                _remoteAddresses[i],
                address(this)
            );
        }

        emit SetBatchTrustedRemoteAddress(_remoteChainIds, _remoteAddresses);
    }

    //--------------------------- INTERNAL FUNCTION ----------------------------------------
    /**
     * @dev handles receiving NFTs that cross over from other chains
     * @param _srcChainId nft source chain id
     * @param _payload toAddress, tokenId, variation co-encoded value
     */
    function _nonblockingLzReceive(
        uint16 _srcChainId,
        bytes memory,
        uint64,
        bytes memory _payload
    ) internal override {
        xenoBunny.receiveProcesser(_srcChainId, _payload);
    }

    //--------------------------- VIEW FUNCTION ----------------------------------------
    /**
     * @dev get the fees needed to launch a cross-chain transaction using layerzero
     */
    function estimateSendFee(
        uint16 _dstChainId,
        bytes memory _payload,
        bytes memory _adapterParams
    ) public view returns (uint256 nativeFee, uint256 zroFee) {
        return
            lzEndpoint.estimateFees(
                _dstChainId,
                address(this),
                _payload,
                false,
                _adapterParams
            );
    }
}
