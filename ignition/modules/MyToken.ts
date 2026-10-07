import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MyTokenDeploy", (m) => {
  const myToken = m.contract("MyToken", ["MyToken", "MT", 18]);
  return { myToken };
});
