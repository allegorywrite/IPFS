// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import 1155 token contract from Openzeppelin
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Example contract to be deployed via https://remix.ethereum.org/ for testing purposes.

contract NFTContract is ERC1155, Ownable {
    using SafeMath for uint256;

    constructor()
        ERC1155(
            "ipfs://QmVDhiFWw11vRzSiSPZ9m3poEMkMtugURKCq1yZS3YozjX/metadata/{id}.json" // You can get this saved in dasboard of your Moralis server instance.
        )
    {
        // account, token_id, number
        _mint(msg.sender, 1, 1, "");
        _mint(msg.sender, 2, 1, "");
        _mint(msg.sender, 3, 1, "");
    }

    /*
    // More to come here.
    function mint(address account, uint256 id, uint256 amount) public onlyOwner {
        _mint(account, id, amount, "");
    }
    function burn(address account, uint256 id, uint256 amount) public {
        require(msg.sender == account);
        _burn(account, id, amount);
    }
    */
}
