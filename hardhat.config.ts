/** @notice library imports */
import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

/// Hardhat config
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
  },
};

export default config;
