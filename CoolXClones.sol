// SPDX-License-Identifier: MIT

/*
 ___  ___  ________  ________  ___       ___  ___  ________      
|\  \|\  \|\   __  \|\   ___ \|\  \     |\  \|\  \|\   __  \     
\ \  \\\  \ \  \|\  \ \  \_|\ \ \  \    \ \  \\\  \ \  \|\  \    
 \ \   __  \ \  \\\  \ \  \ \\ \ \  \    \ \   __  \ \  \\\  \   
  \ \  \ \  \ \  \\\  \ \  \_\\ \ \  \____\ \  \ \  \ \  \\\  \  
   \ \__\ \__\ \_______\ \_______\ \_______\ \__\ \__\ \_____  \ 
    \|__|\|__|\|_______|\|_______|\|_______|\|__|\|__|\|___| \__\
                                                            \|__|
*/

pragma solidity ^0.8.0;

import "./ERC1155Supply.sol";
import "./Ownable.sol";
import "./CoolxClonesVials.sol";
import "./Strings.sol";

contract CoolXClones is ERC1155Supply, Ownable {
  using Strings for uint256;
    
  string public name;
  string public symbol;
  string public baseURI;
  string public baseExtension = '';
  uint256 public totalSupply = 0;
  bool public paused = true;
  CoolxClonesVials public CXCV = CoolxClonesVials(0x7981CBa35d6e0deEAECAD4E5C0ad3685E4EcF33D);

  constructor(
    string memory _BaseURI
    ) ERC1155("") {
    name = "Cool X Clones";
    symbol = "CXC";
    setBaseURI(_BaseURI);
  }

  function revealVial(address _to, uint256 _amount) public {
    require(CXCV.balanceOf(_to, 1) >= _amount);
    require(CXCV.isApprovedForAll(_to, address(this)));

    if(msg.sender != owner()) {
      require(!paused);
      require(msg.sender == _to);
    }

    CXCV.burn(_to, _amount);

    uint256 CXCMintAmount = _amount * 2;
    
    for (uint256 i = 1; i <= CXCMintAmount; i++) {
      _mint(_to, totalSupply + i, 1, "");
    }

    totalSupply += CXCMintAmount;
  }

  function uri(uint _id) public override view returns (string memory) {
    require(exists(_id), "Cool X Clones: URI query for nonexistent token");
 
    return bytes(baseURI).length > 0
        ? string(abi.encodePacked(baseURI, _id.toString(), baseExtension))
        : "";
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
}
    