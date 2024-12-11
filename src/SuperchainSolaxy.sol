// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import {ERC20, IERC20} from "@openzeppelin/contracts@5.1.0/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts@5.1.0/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20FlashMint} from "@openzeppelin/contracts@5.1.0/token/ERC20/extensions/ERC20FlashMint.sol";
import {ERC20Permit} from "@openzeppelin/contracts@5.1.0/token/ERC20/extensions/ERC20Permit.sol";

import {IOptimismMintableERC20} from "./interfaces/IOptimismMintableERC20.sol";
import {IERC7802, IERC165} from "./interfaces/IERC7802.sol";

contract SuperchainSolaxy is IOptimismMintableERC20, IERC7802, ERC20, ERC20Burnable, ERC20Permit, ERC20FlashMint {
    address public constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address public constant L2_STANDARD_BRIDGE = 0x4200000000000000000000000000000000000010;
    address public constant REMOTE_TOKEN = 0x4200000000000000000000000000000000000010; // ToDo: use real L1 contract address

    error Unauthorized();

    event Mint(address indexed account, uint256 amount);
    event Burn(address indexed account, uint256 amount);

    constructor() ERC20("Solaxy", "SLX") ERC20Permit("Solaxy") {}

    function mint(address _to, uint256 _amount) external {
        if (msg.sender != L2_STANDARD_BRIDGE) revert Unauthorized();
        _mint(_to, _amount);
        emit Mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) external {
        if (msg.sender != L2_STANDARD_BRIDGE) revert Unauthorized();
        _burn(_from, _amount);
        emit Burn(_from, _amount);
    }

    function crosschainMint(address _to, uint256 _amount) external {
        if (msg.sender != SUPERCHAIN_TOKEN_BRIDGE) revert Unauthorized();
        _mint(_to, _amount);
        emit CrosschainMint(_to, _amount, msg.sender);
    }

    function crosschainBurn(address _from, uint256 _amount) external {
        if (msg.sender != SUPERCHAIN_TOKEN_BRIDGE) revert Unauthorized();
        _burn(_from, _amount);
        emit CrosschainBurn(_from, _amount, msg.sender);
    }

    function bridge() public pure returns (address) {
        return L2_STANDARD_BRIDGE;
    }

    function remoteToken() public pure returns (address) {
        return REMOTE_TOKEN;
    }

    function supportsInterface(bytes4 _interfaceId) public view virtual returns (bool) {
        return _interfaceId == type(IOptimismMintableERC20).interfaceId || _interfaceId == type(IERC7802).interfaceId
            || _interfaceId == type(IERC20).interfaceId || _interfaceId == type(IERC165).interfaceId;
    }
}
