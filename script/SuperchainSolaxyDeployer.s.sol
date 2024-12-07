// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";
import {SuperchainSolaxy} from "../src/SuperchainSolaxy.sol";

contract SuperchainSolaxyDeployer is Script {
    bytes32 SALT = keccak256(abi.encodePacked("Tasty Superchain Solaxy"));
    string[] chainsToDeployTo = [];

    function setUp() public {}

    function run() public {
        for (uint256 i = 0; i < chainsToDeployTo.length; i++) {
            string memory chainToDeployTo = chainsToDeployTo[i];
            console.log("Deploying to chain: ", chainToDeployTo);
            vm.createSelectFork(chainToDeployTo);
            address deployedAddress = deploySuperchainSolaxy();
        }
    }

    function deploySuperchainSolaxy() public returns (address addr_) {
        bytes memory initCode = abi.encodePacked(type(SuperchainSolaxy).creationCode);
        address preComputedAddress = vm.computeCreate2Address(SALT, keccak256(initCode));

        if (preComputedAddress.code.length > 0) {
            console.log("SuperchainSolaxy already deployed at %s", preComputedAddress, "on chain id: ", block.chainid);
            addr_ = preComputedAddress;
        } else {
            vm.startBroadcast(msg.sender);
            addr_ = address(new SuperchainSolaxy{salt: SALT});
            vm.stopBroadcast();
            console.log("Deployed SuperchainSolaxy at address: ", addr_, "on chain id: ", block.chainid);
        }
    }
}
