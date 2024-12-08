// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";
import {SuperchainSolaxy} from "../src/SuperchainSolaxy.sol";

contract SuperchainSolaxyDeployer is Script {
    bytes32 SALT = keccak256(abi.encodePacked("Superchain"));

    function run() public view {
        console.log(unicode"⏳| Computing address with salt: ");
        address preComputedAddress =
            vm.computeCreate2Address(SALT, keccak256(abi.encodePacked(type(SuperchainSolaxy).creationCode)));
        console.log(unicode"✨| Derived address: ", preComputedAddress);
    }
}
