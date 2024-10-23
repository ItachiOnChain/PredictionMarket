import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const oracleAddress = deployer;

  const deploymentResult = await deploy("YourContract", {
    from: deployer,
    args: [oracleAddress],
    log: true,
    autoMine: true,
  });

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const yourContract: Contract = await hre.ethers.getContract("YourContract", deployer);

  console.log(`YourContract deployed at: ${deploymentResult.address}`);
};

export default deployYourContract;

deployYourContract.tags = ["YourContract"];
