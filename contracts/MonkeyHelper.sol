// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./MonkeyFeeding.sol";

contract MonkeyHelper is MonkeyFeeding {
    uint levelUpFee = 0.001 ether;

    modifier aboveLevel(uint _level, uint _monkeyId) {
        require(monkeys[_monkeyId].level >= _level);
        _;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint _monkeyId) external payable {
        require(msg.value == levelUpFee);
        monkeys[_monkeyId].level++;
    }

    function changeName(
        uint _monkeyId,
        string calldata _newName
    ) external aboveLevel(2, _monkeyId) onlyOwnerOf(_monkeyId) {
        monkeys[_monkeyId].name = _newName;
    }

    function changeDna(
        uint _monkeyId,
        uint _newDna
    ) external aboveLevel(20, _monkeyId) onlyOwnerOf(_monkeyId) {
        monkeys[_monkeyId].dna = _newDna;
    }

    function getMonkeysByOwner(
        address _owner
    ) external view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerMonkeyCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < monkeys.length; i++) {
            if (monkeyToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
