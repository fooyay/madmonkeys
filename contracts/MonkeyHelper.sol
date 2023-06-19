// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./MonkeyFeeding.sol";

contract MonkeyHelper is MonkeyFeeding {
    modifier aboveLevel(uint _level, uint _monkeyId) {
        require(monkeys[_monkeyId].level >= _level);
        _;
    }

    function changeName(
        uint _monkeyId,
        string calldata _newName
    ) external aboveLevel(2, _monkeyId) {
        require(msg.sender == monkeyToOwner[_monkeyId]);
        monkeys[_monkeyId].name = _newName;
    }

    function changeDna(
        uint _monkeyId,
        uint _newDna
    ) external aboveLevel(20, _monkeyId) {
        require(msg.sender == monkeyToOwner[_monkeyId]);
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
