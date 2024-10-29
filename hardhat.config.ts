import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ignition-ethers";

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/0ca56b614fd348be97728040c1879ab2",
      accounts: ['cb84aa43a544e42cc00f743190f74e2639c11d66c1a37c79833bb6c669b91801'],
    },
  },
  etherscan: {
    apiKey: "HW2QZ813M6YKSJS6Z3MS2TQ9B7DR35DWPA"
  }
};

export default config;
