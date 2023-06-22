// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./MonkeyAttack.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MonkeyOwnership is MonkeyAttack, ERC721("Mad Monkeys", "MMONK") {
    mapping(uint => address) monkeyApprovals;

    function balanceOf(address _owner) public view override returns (uint256) {
        return ownerMonkeyCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        return monkeyToOwner[_tokenId];
    }

    // ERC721 has a better _transfer
    function _myTransfer(address _from, address _to, uint256 _tokenId) private {
        ownerMonkeyCount[_to]++;
        ownerMonkeyCount[_from]--;
        monkeyToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(
            monkeyToOwner[_tokenId] == msg.sender ||
                monkeyApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(
        address _approved,
        uint256 _tokenId
    ) public override onlyOwnerOf(_tokenId) {
        monkeyApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
