import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0xaDBA987955Eac146f1983062100046be46e632fA";

const StakingERC20Module = buildModule("ERC20StakingModule", (m) => {
  const staking = m.contract("ERC20Staking", [tokenAddress]);
  return { staking };
});

export default StakingERC20Module;
// https://sepolia-blockscout.lisk.com//address/0x803c540FFD450E73A77D3601df1b198503774607#code