// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CoolxClonesVials {
  function burn(address account, uint256 _amount) public virtual {}
  function balanceOf(address account, uint256 id) public view virtual returns (uint256) {}
  function isApprovedForAll(address account, address operator) public view virtual returns (bool) {}
}
    