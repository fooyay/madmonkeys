// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// import "./Ownable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// for random numbers using VRF - disabled for now
// import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

// disable VRF for now
// contract MonkeyFactory is Ownable, VRFConsumerBase {
contract MonkeyFactory is Ownable {
  using SafeMath for uint256;

  event NewMonkey(uint monkeyId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  // Chainlink random number generator variables
  /* disable Chainlink for now
  bytes32 public keyHash;
  uint256 public fee;
  uint256 public randomResult;
  */

  struct Monkey {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }
  Monkey[] public monkeys;

  // Main net:
  // VRF 0x271682DEB8C4E0901D1a1550aD2e64D568E69909
  // LINK 0x514910771AF9Ca656af840dff83E8264EcF986CA
  // Sepolia:
  // VRF 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
  // LINK 0x779877A7B0D9E8603169DdbD7836e478b4624789
  /* disable Chainlink for now
  constructor()
    VRFConsumerBase(
      0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
      0x779877A7B0D9E8603169DdbD7836e478b4624789
    )
  {
    keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
    fee = 100000000000000000;
  }
  */

  mapping(uint => address) public monkeyToOwner;
  mapping(address => uint) ownerMonkeyCount;

  function _createMonkey(string memory _name, uint _dna) internal {
    monkeys.push(
      Monkey(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0)
    );
    uint id = monkeys.length - 1;
    monkeyToOwner[id] = msg.sender;
    ownerMonkeyCount[msg.sender]++;
    emit NewMonkey(id, _name, _dna);
  }

  /* disable VRF for now
  function getRandomNumber() public returns (bytes32 requestId) {
    return requestRandomness(keyHash, fee);
  }

  function fulfillRandomness(
    bytes32 requestId,
    uint256 randomness
  ) internal override {
    randomResult = randomness;
  }
  */

  // if we switch to using VRF, comment out this function or modify it to the randomness
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
