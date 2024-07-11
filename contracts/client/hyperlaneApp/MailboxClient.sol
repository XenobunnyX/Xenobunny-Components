// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

// ============ Internal Imports ============
import "../../libraries/XenoAppErrors.sol";
import {IMailbox} from "../../interfaces/IMailbox.sol";
import {IPostDispatchHook} from "../../interfaces/IPostDispatchHook.sol";
import {IInterchainSecurityModule} from "../../interfaces/IInterchainSecurityModule.sol";
import {StandardHookMetadata} from "../../libraries/StandardHookMetadata.sol";
import {Message} from "../../libraries/Message.sol";
import {TypeCasts} from "../../libraries/TypeCasts.sol";

// ============ External Imports ============
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

abstract contract MailboxClient is Ownable {
    using Message for bytes;

    IMailbox public immutable mailbox;

    uint32 public immutable localDomain;

    IPostDispatchHook public hook;

    IInterchainSecurityModule public interchainSecurityModule;

    /**
     * @notice Only accept messages from an Hyperlane Mailbox contract
     */
    modifier onlyMailbox() {
        if (msg.sender != address(mailbox))
            revert InvalidEndpointCaller(msg.sender);
        _;
    }

    constructor(address _owner, address _mailbox) Ownable(_owner) {
        mailbox = IMailbox(_mailbox);
        localDomain = mailbox.localDomain();
    }

    /**
     * @notice Sets the address of the application's custom hook.
     * @param _hook The address of the hook contract.
     */
    function setHook(address _hook) public onlyOwner {
        hook = IPostDispatchHook(_hook);
    }

    /**
     * @notice Sets the address of the application's custom interchain security module.
     * @param _module The address of the interchain security module contract.
     */
    function setInterchainSecurityModule(address _module) public onlyOwner {
        interchainSecurityModule = IInterchainSecurityModule(_module);
    }

    function _isLatestDispatched(bytes32 id) internal view returns (bool) {
        return mailbox.latestDispatchedId() == id;
    }

    function _isDelivered(bytes32 id) internal view returns (bool) {
        return mailbox.delivered(id);
    }

    function _dispatch(
        uint32 _destinationDomain,
        bytes32 _recipient,
        uint256 _gasLimit,
        bytes memory _messageBody,
        bytes memory _customBytes
    ) internal virtual returns (bytes32) {
        return
            _dispatch(
                _destinationDomain,
                _recipient,
                msg.value,
                _gasLimit,
                _messageBody,
                _customBytes
            );
    }

    function _dispatch(
        uint32 _destinationDomain,
        bytes32 _recipient,
        uint256 _value,
        uint256 _gasLimit,
        bytes memory _messageBody,
        bytes memory _customBytes
    ) internal virtual returns (bytes32) {
        return
            mailbox.dispatch{value: _value}(
                _destinationDomain,
                _recipient,
                _messageBody,
                StandardHookMetadata.formatMetadata(
                    uint256(0),
                    _gasLimit,
                    TypeCasts.bytes32ToAddress(_recipient),
                    _customBytes
                ),
                hook
            );
    }

    function _dispatch(
        uint32 _destinationDomain,
        bytes32 _recipient,
        uint256 _value,
        bytes memory _messageBody,
        bytes memory _hookMetadata,
        IPostDispatchHook _hook
    ) internal virtual returns (bytes32) {
        return
            mailbox.dispatch{value: _value}(
                _destinationDomain,
                _recipient,
                _messageBody,
                _hookMetadata,
                _hook
            );
    }

    function _quoteDispatch(
        uint32 _destinationDomain,
        bytes32 _recipient,
        uint256 _value,
        uint256 _gasLimit,
        bytes memory _messageBody,
        bytes memory _customBytes
    ) internal view virtual returns (uint256) {
        return
            mailbox.quoteDispatch(
                _destinationDomain,
                _recipient,
                _messageBody,
                StandardHookMetadata.formatMetadata(
                    _value,
                    _gasLimit,
                    TypeCasts.bytes32ToAddress(_recipient),
                    _customBytes
                ),
                hook
            );
    }

    function _quoteDispatch(
        uint32 _destinationDomain,
        bytes32 _recipient,
        bytes memory _messageBody,
        bytes calldata _hookMetadata,
        IPostDispatchHook _hook
    ) internal view virtual returns (uint256) {
        return
            mailbox.quoteDispatch(
                _destinationDomain,
                _recipient,
                _messageBody,
                _hookMetadata,
                _hook
            );
    }
}
