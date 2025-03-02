// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./FundMe.sol";

contract FundTokenERC20 is ERC20{

    error FundAmountNotEnough(address currentUser, uint256 _targetMintAmount);

    FundMe fundMe;

    constructor() ERC20("FundMeToken", "FT") {
        fundMe = FundMe(0xE86Ed337a90A6169765A842Dc85eaBDa3df0752E);
    }

    function mint(uint256 _mintAmount) external {
        uint256 fundAmount = fundMe.funders(msg.sender);

        if (fundAmount == 0 || _mintAmount > fundAmount) {
            revert FundAmountNotEnough(msg.sender, _mintAmount);
        }

        _mint(msg.sender, _mintAmount);

        
    }
}