// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";
import {SuperchainSolaxy} from "../src/SuperchainSolaxy.sol";

contract SuperchainSolaxyDeployer is Script {
    bytes32 SALT = keccak256(abi.encodePacked("Tasty Superchain Solaxy"));
    string[] targetChains = [
        "mainnet/op",
        "mainnet/base",
        "mainnet/celo",
        "mainnet/mode",
        "mainnet/unichain",
        "mainnet/worldchain",
        "mainnet/zora"
    ];

    function setUp() public {}

    function run() public {
        for (uint256 i = 0; i < targetChains.length; i++) {
            string memory target = targetChains[i];
            string memory targetRPC = vm.rpcUrl(target);
            console.log("Deploying to: ", target);
            vm.createSelectFork(targetRPC);
            deploySuperchainSolaxy();
        }
    }

    function deploySuperchainSolaxy() public {
        bytes memory initCode = abi.encodePacked(type(SuperchainSolaxy).creationCode);
        address solaxy = vm.computeCreate2Address(SALT, keccak256(initCode));

        if (solaxy.code.length > 0) {
            console.log("SuperchainSolaxy already deployed at %s", solaxy, "on chain id: ", block.chainid);
        } else {
            vm.startBroadcast(msg.sender);
            solaxy = address(new SuperchainSolaxy{salt: SALT}());
            vm.stopBroadcast();
            console.log("Deployed SuperchainSolaxy at address: ", solaxy, "on chain id: ", block.chainid);
        }
    }
}
