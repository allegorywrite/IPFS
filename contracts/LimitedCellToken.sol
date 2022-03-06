// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract LimitedCellToken is ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenCounter;

    uint256 constant MAX_INVITE = 2;

    mapping(address => uint256) memberInviteCount;
    mapping(address => uint256) rankCount;

    constructor() ERC721("LimitedCellToken", "Limited") {
      rankCount[msg.sender] = 0;
    }

  modifier onlyOwnerOrMember() {
    require(
      msg.sender == owner() || balanceOf(msg.sender) >= 1,
      "not member"
    );
    _;
  }

  modifier caninvite(address _to) {
    require(
      (msg.sender == owner() || memberInviteCount[msg.sender] < MAX_INVITE) 
      && balanceOf(_to) <= 0,
      "cannot invite"
    );
    _;
  }

  function mintAndTransfer(address _to, string memory _tokenURI) public onlyOwnerOrMember caninvite(_to)  {
    _tokenCounter.increment();

    uint256 _newItemId = _tokenCounter.current();
    _safeMint(msg.sender, _newItemId);
    safeTransferFrom(msg.sender, _to, _newItemId);
    _setTokenURI(_newItemId, _tokenURI);

    memberInviteCount[msg.sender] = memberInviteCount[msg.sender].add(1);
    rankCount[_to] = rankCount[msg.sender].add(1);
  }

  function getTotalSupply() external view returns (uint256) {
    return _tokenCounter.current();
  }
}