/** @notice library imports */
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

/// Secura module.
const SecuraModule = buildModule("SecuraModule", (m) => {
  const secura = m.contract("Secura");
  return { secura };
});

export default SecuraModule;
