// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./HlApp.sol";
import "../../interfaces/IXenoTravel.sol";
import "../../interfaces/IXenoSystem.sol";

contract HyperlaneApp is HlApp, IXenoTravel {
    IXenoSystem public xenoBunny;

    mapping(uint16 => uint32) public formatIdMapHlId;
    mapping(uint32 => uint16) public hlIdMapFormatId;

    event SetFormatChainIdMapHyperlaneChainId(
        uint16 _formatChainId,
        uint32 _hlChainId
    );
    event SetFormatChainIdMapHyperlaneChainIdBatch(
        uint16[] _formatChainIds,
        uint32[] _hlChainIds
    );

    constructor(
        address _initOwner,
        address _mailbox,
        address _xenoAddress
    ) HlApp(_initOwner, _mailbox) {
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
        if (formatIdMapHlId[_dstChainId] == 0) revert InvalidDstChain();

        _hlSend(
            formatIdMapHlId[_dstChainId],
            _payload,
            payable(_sender),
            _adapterParams,
            msg.value
        );
    }

    //--------------------------- INTERNAL FUNCTION ----------------------------------------
    function _nonblockingHlReceive(
        uint32 _srcChainId,
        bytes32 /* _srcAddress */,
        bytes memory _playload
    ) internal virtual override {
        xenoBunny.receiveProcesser(hlIdMapFormatId[_srcChainId], _playload);
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
     * @notice setting format chain ID map Hyperlane chain ID
     */
    function setFormatChainIdMapHlChainId(
        uint16 _formatId,
        uint32 _hlId
    ) external onlyOwner {
        formatIdMapHlId[_formatId] = _hlId;
        hlIdMapFormatId[_hlId] = _formatId;

        emit SetFormatChainIdMapHyperlaneChainId(_formatId, _hlId);
    }

    /**
     * @notice setting format chain ID map Hyperlane chain ID
     */
    function setFormatChainIdMapHlChainIdBatch(
        uint16[] memory _formatIds,
        uint32[] memory _hlIds
    ) external onlyOwner {
        if (_formatIds.length != _hlIds.length) revert InvalidParams();

        for (uint i = 0; i < _formatIds.length; i++) {
            formatIdMapHlId[_formatIds[i]] = _hlIds[i];
            hlIdMapFormatId[_hlIds[i]] = _formatIds[i];
        }

        emit SetFormatChainIdMapHyperlaneChainIdBatch(_formatIds, _hlIds);
    }

    //--------------------------- VIEW FUNCTION ----------------------------------------
    /**
     * @notice get the fees needed to launch a cross-chain transaction using hyperlane
     */
    function estimateSendFee(
        uint16 _dstChainId,
        bytes memory _payload,
        bytes calldata _adapterParams
    ) external view override returns (uint256 nativeFee, uint256 protocalFee) {
        (uint gasLimit, bytes memory customBytes) = _checkHlAdapterConfig(
            formatIdMapHlId[_dstChainId],
            _adapterParams
        );
        nativeFee = _quoteDispatch(
            formatIdMapHlId[_dstChainId],
            TypeCasts.addressToBytes32(msg.sender),
            uint256(0),
            gasLimit,
            _payload,
            customBytes
        );
        protocalFee = 0;
    }
}
