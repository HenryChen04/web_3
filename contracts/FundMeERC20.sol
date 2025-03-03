// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

contract FundTokenERC20 is ERC20{

    error FundAmountNotEnough(address currentUser, uint256 _targetMintAmount);

    FundMe private fundMe;

    constructor() ERC20("FundMeToken", "FT") {
        fundMe = FundMe(0xE86Ed337a90A6169765A842Dc85eaBDa3df0752E);
    }

    function mint(uint256 _mintAmount) external {

        uint256 fundAmount = fundMe.funders(msg.sender);

        if (fundAmount == 0 || _mintAmount > fundAmount) {
            revert FundAmountNotEnough(msg.sender, _mintAmount);
        }

        require(fundMe.getFundResult(), "Getting fund is unsuccessful");

        _mint(msg.sender, _mintAmount);

        fundMe.setFundAmount(msg.sender, fundAmount - _mintAmount);
    }

     function burn(uint256 burnFundTokenAmount) external {
        uint256 balance = balanceOf(msg.sender);

        require(balance >= burnFundTokenAmount, "You have not enought fund token");

        require(fundMe.getFundResult(), "Getting fund is unsuccessful");

        _burn(msg.sender, burnFundTokenAmount);
     }
}