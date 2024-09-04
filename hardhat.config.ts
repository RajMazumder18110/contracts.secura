/** @notice library imports */
import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import "dotenv/config";

/// Hardhat config
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
  },

  /// Verification
  etherscan: {
    apiKey: {
      /// Polygon
      amoy: process.env.POLYGON_SCAN_API as string,
      polygon: process.env.POLYGON_SCAN_API as string,
    },

    /// Amoy chain
    customChains: [
      {
        network: "amoy",
        chainId: 80002,
        urls: {
          browserURL: "https://amoy.polygonscan.com/",
          apiURL: "https://api-amoy.polygonscan.com/api/",
        },
      },
    ],
  },

  /// Networks
  networks: {
    /// Polygon
    amoy: {
      url: `https://rpc-amoy.polygon.technology/`,
      chainId: 80002,
      accounts: [`0x${process.env.DEPLOYER_PRIVATE_KEY}`],
    },
  },
};

export default config;
