// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./VoApp.sol";
import "../../interfaces/IXenoTravel.sol";
import "../../interfaces/IXenoSystem.sol";

contract VizingApp is VoApp, IXenoTravel {
    //---------------------------  STATE VARIABLES  ----------------------------------------
    IXenoSystem public xenoBunny;

    mapping(uint16 => uint64) public formatIdMapVizingId;
    mapping(uint64 => uint16) public vizingIdMapFormatId;

    //--------------------------- EVENTS ----------------------------------------
    event SetFormatChainIdMapVizingChainId(
        uint16 _formatChainId,
        uint64 _hlChainId
    );
    event SetFormatChainIdMapVizingChainIdBatch(
        uint16[] _formatChainIds,
        uint64[] _hlChainIds
    );

    //--------------------------- CONSTRUCTOR ----------------------------------------
    constructor(
        address _owner,
        address _vizingEndpoint,
        address _xenoAddress
    ) VoApp(_vizingEndpoint, _owner) {
        xenoBunny = IXenoSystem(_xenoAddress);
    }

    function travel(
        address _sender,
        uint16 _dstChainId,
        bytes memory _payload,
        bytes calldata _adapterParams
    ) external payable override {
        if (_msgSender() != address(xenoBunny))
            revert InvalidEndpointCaller(_msgSender());
        if (_adapterParams.length < 32) revert InvalidAdapterParams();
        if (formatIdMapVizingId[_dstChainId] == 0) revert InvalidDstChain();

        _voSend(
            formatIdMapVizingId[_dstChainId],
            _payload,
            payable(_sender),
            _adapterParams,
            msg.value
        );
    }

    //--------------------------- INTERNAL FUNCTION ----------------------------------------
    function _nonblockingVoReceive(
        uint64 _srcChainId,
        address /* _srcAddress */,
        bytes memory _payload
    ) internal virtual override {
        xenoBunny.receiveProcesser(vizingIdMapFormatId[_srcChainId], _payload);
    }

    //--------------------------- SETTING FUNCTION ----------------------------------------
    /**
     * @notice setting xenobunny address
     */
    function setXeno(address _xeno) external onlyOwner {
        xenoBunny = IXenoSystem(_xeno);
    }

    /**
     * @notice withdrawal fees
     */
    function withdrawByAdmin(address _receiver) external onlyOwner {
        payable(_receiver).transfer(address(this).balance);
    }

    /**
     * @notice setting format chain ID map vizing chain ID
     */
    function setFormatChainIdMapVizingChainId(
        uint16 _formatId,
        uint64 _hlId
    ) external onlyOwner {
        formatIdMapVizingId[_formatId] = _hlId;
        vizingIdMapFormatId[_hlId] = _formatId;

        emit SetFormatChainIdMapVizingChainId(_formatId, _hlId);
    }

    /**
     * @notice setting format chain ID map vizing chain ID
     */
    function setFormatChainIdMapVizingChainIdBatch(
        uint16[] memory _formatIds,
        uint64[] memory _hlIds
    ) external onlyOwner {
        if (_formatIds.length != _hlIds.length) revert InvalidParams();

        for (uint i = 0; i < _formatIds.length; i++) {
            formatIdMapVizingId[_formatIds[i]] = _hlIds[i];
            vizingIdMapFormatId[_hlIds[i]] = _formatIds[i];
        }

        emit SetFormatChainIdMapVizingChainIdBatch(_formatIds, _hlIds);
    }

    //--------------------------- VIEW FUNCTION ----------------------------------------
    /**
     * @notice get the fees needed to launch a cross-chain transaction using vizing
     */
    function estimateSendFee(
        uint16 _dstChainId,
        bytes memory _payload,
        bytes calldata _adapterParams
    ) external view override returns (uint256 nativeFee, uint256 protocalFee) {
        uint64 vizingDstChainId = formatIdMapVizingId[_dstChainId];
        address trustedRemote = trustedRemoteLookup[vizingDstChainId];
        bytes memory _sPlayload = _payload; /// avoid stack too deep
        (
            uint transferValue,
            uint gasLimit,
            uint gasPrice,
            bytes memory customBytes
        ) = _checkVoAdapterConfig(vizingDstChainId, _adapterParams);
        bytes memory encodedMessage = _packetMessage(
            this.defaultBridgeMode(),
            trustedRemote,
            uint24(gasLimit),
            uint64(gasPrice),
            _sPlayload
        );

        uint256 estimateFee = _estimateVizingGasFee(
            transferValue,
            vizingDstChainId,
            customBytes,
            encodedMessage
        );
        nativeFee = estimateFee + transferValue;
        protocalFee = 0;
    }
}
