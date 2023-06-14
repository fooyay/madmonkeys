// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract MonkeyFactory {

    event NewMonkey(uint monkeyId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Monkey {
        string name;
        uint dna;
    }
    Monkey[] public monkeys;

    mapping (uint => address) public monkeyToOwner;
    mapping (address => uint) ownerMonkeyCount;

    function _createMonkey(string memory _name, uint _dna) private {
        monkeys.push(Monkey(_name, _dna));
        uint id = monkeys.length - 1;
        monkeyToOwner[id] = msg.sender;
        ownerMonkeyCount[msg.sender]++;
        emit NewMonkey(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        require(ownerMonkeyCount[msg.sender] == 0);
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomMonkey(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createMonkey(_name, randDna);
    }
}
