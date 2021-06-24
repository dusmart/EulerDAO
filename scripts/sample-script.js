async function main() {

  const EulerDAO = await hre.ethers.getContractFactory("EulerDAO");
  const greeter = await EulerDAO.deploy();
  await greeter.deployed();

  console.log("Greeter deployed to:", greeter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
