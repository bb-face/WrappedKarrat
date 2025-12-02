// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/WKARRAT.sol";

contract DeployWKARRAT is Script {
    function run() external returns (WKARRAT) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        WKARRAT wkarrat = new WKARRAT();
        
        vm.stopBroadcast();
        
        console.log("WKARRAT deployed at:", address(wkarrat));
        
        return wkarrat;
    }
}
