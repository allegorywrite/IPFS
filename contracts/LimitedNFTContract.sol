// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract LimitedNFT is ERC1155, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenCounter;

    uint256 constant MAX_INVITE = 2;
    string private _name;
    string private _symbol;

    mapping(address => uint256) memberInviteCount;
    mapping(address => uint256) rankCount;

  constructor()
    ERC1155(
        "ipfs://QmVDhiFWw11vRzSiSPZ9m3poEMkMtugURKCq1yZS3YozjX/metadata/{id}.json"
    ){
      rankCount[msg.sender] = 0;
      _name = "LimitedCellToken";
      _symbol = "Cell";      
    }

  modifier onlyOwnerOrMember(uint256 _id) {
    require(
      msg.sender == owner() || balanceOf(msg.sender, _id) >= 1,
      "not member"
    );
    _;
  }

  modifier caninvite(address _to, uint256 _id) {
    require(
      (msg.sender == owner() || memberInviteCount[msg.sender] < MAX_INVITE) 
      && balanceOf(_to, _id) <= 0,
      "cannot invite"
    );
    _;
  }

  function mintAndTransfer(address _to, uint256 _newItemId) public onlyOwnerOrMember(_newItemId) caninvite(_to, _newItemId)  {

    _tokenCounter.increment();
    _mint(msg.sender, _newItemId,1,"");
    safeTransferFrom(msg.sender, _to, _newItemId, 1, "");

    memberInviteCount[msg.sender] = memberInviteCount[msg.sender].add(1);
    rankCount[_to] = rankCount[msg.sender].add(1);
  }

  function getTotalSupply() external view returns (uint256) {
    return _tokenCounter.current();
  }

  function name() public view virtual returns (string memory) {
      return _name;
  }

  function symbol() public view virtual returns (string memory) {
      return _symbol;
  }
}
