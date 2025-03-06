// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MyToken} from "./MyToken.sol";

contract WrappedMyToken is MyToken{
    
    constructor(address initialOwner) MyToken(initialOwner) {}

    function mintWithSpecificId(address to, uint256 tokenId) external {
        _safeMint(to, tokenId);
    }
}