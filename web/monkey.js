var abi = // tbd
var MonkeyFactoryContract = web3.eth.contract(abi)
var contractAddress = tbd
var MonkeyFactory = MonkeyFactoryContract.at(contractAddress)

$("#ourButton").click(function(e) {
  var name = $("#nameInput").val()
  MonkeyFactory.createRandomMonkey(name)
})

var event = MonkeyFactory.NewMonkey(function(error, result) {
  if (error) return
  generateMonkey(result.MonkeyId, result.name, result.dna)
})

function generateMonkey(id, name, dna) {
  let dnaStr = String(dna)
  // pad DNA with leading zeroes if it's less than 16 characters
  while (dnaStr.length < 16)
    dnaStr = "0" + dnaStr

  let MonkeyDetails = {
    // first 2 digits make up the head. We have 7 possible heads, so % 7
    // to get a number 0 - 6, then add 1 to make it 1 - 7. Then we have 7
    // image files named "head1.png" through "head7.png" we load based on
    // this number:
    headChoice: dnaStr.substring(0, 2) % 7 + 1,
    // 2nd 2 digits make up the eyes, 11 variations:
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    // 6 variations of shirts:
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    // last 6 digits control color. Updated using CSS filter: hue-rotate
    // which has 360 degrees:
    skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
    clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
    MonkeyName: name,
    MonkeyDescription: "A Level 1 CryptoMonkey",
  }
  return MonkeyDetails
}