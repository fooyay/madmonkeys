// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import "./MonkeyFactory.sol";

contract MonkeyFeeding is MonkeyFactory {
    function feedAndMultiply(uint _monkeyId, uint _targetDna) public {
        require(msg.sender == monkeyToOwner[_monkeyId]);
        Monkey storage myMonkey = monkeys[_monkeyId];

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myMonkey.dna + _targetDna) / 2;
        _createMonkey("NoName", newDna);
    }
}