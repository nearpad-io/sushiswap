// const { WETH } = require("@sushiswap/sdk");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  const chainId = await getChainId();

  let wethAddress;

  if (chainId === "31337") {
    wethAddress = (await deployments.get("WETH9Mock")).address;
  } if (chainId === "1313161554") {
      wethAddress = "0xC9BdeEd33CD01541e1eeD10f90519d2C06Fe3feB";  
  // } else if (chainId in WETH) {
  //   wethAddress = WETH[chainId].address;
  } else {
    throw Error("No WETH!");
  }

  const factoryAddress = (await deployments.get("UniswapV2Factory")).address;

  await deploy("UniswapV2Router02", {
    from: deployer,
    args: [factoryAddress, wethAddress],
    log: true,
    deterministicDeployment: false,
  });
};

module.exports.tags = ["UniswapV2Router02", "AMM"];
module.exports.dependencies = ["UniswapV2Factory", "Mocks"];
