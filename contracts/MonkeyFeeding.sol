// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./MonkeyFactory.sol";

abstract contract KittyInterface {
    function getKitty(
        uint256 _id
    )
        external
        view
        virtual
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract MonkeyFeeding is MonkeyFactory {
    KittyInterface kittyContract;

    modifier onlyOwnerOf(uint _monkeyId) {
        require(msg.sender == monkeyToOwner[_monkeyId]);
        _;
    }

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Monkey storage _monkey) internal {
        _monkey.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Monkey storage _monkey) internal view returns (bool) {
        return (_monkey.readyTime <= block.timestamp);
    }

    function feedAndMultiply(
        uint _monkeyId,
        uint _targetDna,
        string memory _species
    ) internal onlyOwnerOf(_monkeyId) {
        Monkey storage myMonkey = monkeys[_monkeyId];
        require(_isReady(myMonkey));

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myMonkey.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createMonkey("NoName", newDna);
        _triggerCooldown(myMonkey);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
