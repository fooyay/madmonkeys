// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract MonkeyFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Monkey {
        string name;
        uint dna;
    }
    Monkey[] public monkeys;

    function createMonkey(string memory _name, uint _dna) public {}

}
