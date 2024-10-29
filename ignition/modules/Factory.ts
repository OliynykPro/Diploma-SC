import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const FactoryModule = buildModule("FactoryModule", (m) => {
  const factory = m.contract("Factory");

  m.call(factory, "setAdmin", ["0x7e2b5fb5198c7dDe774c563D896e6acE3203312C"])

  return { factory };
});

export default FactoryModule;