const { ethers } = require("ethers");

async function main() {
  const SampleProblem = await hre.ethers.getContractFactory("SampleProblem");
  const p = await SampleProblem.deploy();
  await p.check("0x00", "0x00")
  // const EulerDAO = await hre.ethers.getContractFactory("EulerDAO");
  // const Library = await hre.ethers.getContractFactory("Library");
  // console.log(Library.bytecode)
  // console.log(Library.bytecode.length)
  // const greeter = await EulerDAO.deploy();
  // const a1 = ethers.utils.keccak256(Library.bytecode);
  // const a2 = await greeter.get_addr(1, a1)
  // const ccc = await artifacts.readArtifact('Library')
  // const ccccode = ccc.deployedBytecode.replace('0000000000000000000000000000000000000000', a2.substring(2))
  // const lllllllll = ethers.utils.keccak256(ccccode)
  // await greeter.deployed();
  // await greeter.lock_solution(1, lllllllll);
  // await greeter.submit_code(0, Library.bytecode);
  // console.log('---')

  // console.log(ethers.utils.keccak256(code))
  // console.log("Greeter deployed to:", greeter.address);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
