// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// import "./Ownable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MonkeyFactory is Ownable {
    event NewMonkey(uint monkeyId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Monkey {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }
    Monkey[] public monkeys;

    mapping(uint => address) public monkeyToOwner;
    mapping(address => uint) ownerMonkeyCount;

    function _createMonkey(string memory _name, uint _dna) internal {
        monkeys.push(
            Monkey(_name, _dna, 1, uint32(block.timestamp + cooldownTime))
        );
        uint id = monkeys.length - 1;
        monkeyToOwner[id] = msg.sender;
        ownerMonkeyCount[msg.sender]++;
        emit NewMonkey(id, _name, _dna);
    }

    function _generateRandomDna(
        string memory _str
    ) private view returns (uint) {
        require(ownerMonkeyCount[msg.sender] == 0);
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomMonkey(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createMonkey(_name, randDna);
    }
}
