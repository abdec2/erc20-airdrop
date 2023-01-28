// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface Decimal {
    function decimals() external returns(uint8);
}

contract Airdrop is Ownable, ReentrancyGuard {

    using SafeERC20 for IERC20;
    event Transfer(address indexed from, address indexed to, uint value);


    constructor() {}

    function airdrop(
        address _tokenAddress,
        address _tokenOwner,
        address[] memory _recipients,
        uint256[] memory _amount
    ) external nonReentrant onlyOwner {
        uint256 len = _amount.length;
        require(len == _recipients.length, "length mismatch");
        
        IERC20 token = IERC20(_tokenAddress);
        uint decimals = Decimal(_tokenAddress).decimals();

        for (uint256 i = 0; i < len; i++) {
            require(_recipients[i] != address(0), "zero adddress not allowed");
            require(_amount[i] != 0, "amount should be greater than zero");
            token.safeTransferFrom(_tokenOwner, _recipients[i], _amount[i] * 10 ** decimals);
            emit Transfer(_tokenOwner, _recipients[i], _amount[i] * 10 ** decimals);
        }
    }
    
}