// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FundMeERC20 is ERC20{

    constructor() ERC20("FundMeToken", "FT") {

    }

    
}