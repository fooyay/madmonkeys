// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./MonkeyHelper.sol";

contract MonkeyAttack is MonkeyHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;
        return
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    function attack(
        uint _monkeyId,
        uint _targetId
    ) external onlyOwnerOf(_monkeyId) {
        Monkey storage myMonkey = monkeys[_monkeyId];
        Monkey storage enemyMonkey = monkeys[_targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myMonkey.winCount++;
            myMonkey.level++;
            enemyMonkey.lossCount++;
            feedAndMultiply(_monkeyId, enemyMonkey.dna, "monkey");
        } else {
            myMonkey.lossCount++;
            enemyMonkey.winCount++;
            _triggerCooldown(myMonkey);
        }
    }
}
