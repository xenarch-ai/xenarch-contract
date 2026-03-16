// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/test/MockUSDC.sol";

contract DeployMockUSDC is Script {
    function run() external {
        vm.startBroadcast();
        MockUSDC mockUsdc = new MockUSDC();
        vm.stopBroadcast();

        console.log("MockUSDC deployed to:", address(mockUsdc));
    }
}
