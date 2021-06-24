const { expect } = require("chai");

describe("Euler DAO", function() {
  const ctx = {};

  before("post problem", async function() {
    const EulerDAO = await ethers.getContractFactory("EulerDAO");
    const eulerDAO = await upgrades.deployProxy(EulerDAO, []);
    await eulerDAO.deployed();
    const SampleProblem = await ethers.getContractFactory("SampleProblem");
    const sampleProblem = await SampleProblem.deploy();
    await sampleProblem.deployed();
    await eulerDAO.register_problem(sampleProblem.address);

    ctx.eulerDAO = eulerDAO;
  })
  it("lock and post solution", async function() {
    const SampleSolutionArtifact = await artifacts.readArtifact('SampleSolution');
    const bytecode = ethers.utils.keccak256(SampleSolutionArtifact.bytecode);
    const target = 0;
    const predictedAddr = await ctx.eulerDAO.get_addr(target, bytecode);
    const code = SampleSolutionArtifact.deployedBytecode.replace('0000000000000000000000000000000000000000', predictedAddr.substring(2))
    const digest = ethers.utils.keccak256(code);
    await ctx.eulerDAO.lock_solution(target, digest);
    expect((await ctx.eulerDAO.ownerOf(0))).equal((await ethers.getSigner()).address);
    await ctx.eulerDAO.submit_code(target, SampleSolutionArtifact.bytecode);
    expect(await ctx.eulerDAO.scores(0)).equal(0);

    const score0 = 774;
    await ctx.eulerDAO.compete(target, score0, {value: ethers.utils.parseEther("2")});
    expect(await ctx.eulerDAO.scores(0)).equal(score0);
    const SampleSolution = new ethers.utils.Interface(['function max(uint256 a, uint256 b) external pure returns (uint256)']);
    const challenge = SampleSolution.encodeFunctionData('max', [1,2]);
    await ctx.eulerDAO.lock_challenge(ethers.utils.keccak256(challenge));
    await ctx.eulerDAO.challenge(0, challenge);
    expect(await ctx.eulerDAO.scores(0)).equal(0);
  });
});
