/** @notice Library imports */
import { expect } from "chai";
import { isAddress } from "viem";
import { viem, ignition } from "hardhat";
import type {
  PublicClient,
  GetContractReturnType,
} from "@nomicfoundation/hardhat-viem/src/types";
import { time } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";

/** @notice External imports */
import SecuraModule from "../ignition/modules/Secura";
import { Secura$Type } from "../artifacts/contracts/Secura.sol/Secura";

describe("Secura", function () {
  /// Caching variables.
  let publicClient: PublicClient;
  let Secura: GetContractReturnType<Secura$Type["abi"]>;

  /**
   * @description Initial deployments & helpers.
   *  - Cache publicClient.
   *  - Deploy Secura contracts.
   */
  before(async () => {
    /// Cache publicClient.
    publicClient = await viem.getPublicClient();

    /// Deploy Secura contract.
    const { secura } = await ignition.deploy(SecuraModule);
    Secura = secura;
  });

  describe("Deployment", () => {
    it("Should deploy Secura contract perfectly.", async () => {
      expect(Secura.address).not.to.be.undefined;
      expect(isAddress(Secura.address)).to.be.true;
    });
  });
});
