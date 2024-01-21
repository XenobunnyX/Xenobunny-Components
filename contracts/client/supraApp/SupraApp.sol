// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/ISupraRouter.sol";

abstract contract SupraApp {
    ISupraRouter internal supraRouter;

    function __SupraApp_init(address _server) internal {
        supraRouter = ISupraRouter(_server);
    }
}
