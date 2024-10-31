import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'solidity-coverage';
import 'hardhat-gas-reporter';

const config: HardhatUserConfig = {
  networks: {
    // hardhat: {},
    local: {
      url: 'http://127.0.0.1:8545/',
      //test account
      accounts: ['0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'],
    },
  },
  solidity: '0.8.27',
  gasReporter: {
    enabled: true,
  },
};

export default config;
