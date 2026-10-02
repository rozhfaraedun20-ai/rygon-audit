// SPDX-License-Identifier: MIT
// Legacy Beta Contract (originally deployed as Kurd Coin / KC)
pragma solidity 0.8.27;

import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

/**
 * @title RygonTimelock
 * @notice Production-grade OpenZeppelin TimelockController for Rygon governance.
 *         Enforces a minimum time delay between queueing an administrative action
 *         and executing it, protecting against rogue keys and unexpected updates.
 */
contract RygonTimelock is TimelockController {
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors,
        address admin
    ) TimelockController(minDelay, proposers, executors, admin) {}
}
