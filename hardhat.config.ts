import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers"
import "dotenv/config";
import "./tasks";

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHEREUM_RPC_URL = process.env.ETHEREUM_RPC_URL;
const ETHEREUM_SEPOLIA_RPC_URL = process.env.ETHEREUM_SEPOLIA_RPC_URL;
const POLYGON_MUMBAI_RPC_URL = process.env.POLYGON_MUMBAI_RPC_URL;
const OPTIMISM_GOERLI_RPC_URL = process.env.OPTIMISM_GOERLI_RPC_URL;
const ARBITRUM_GOERLI_RPC_URL = process.env.ARBITRUM_GOERLI_RPC_URL;
const AVALANCHE_FUJI_RPC_URL = process.env.AVALANCHE_FUJI_RPC_URL;
const BASE_GOERLI_RPC_URL = process.env.BASE_GOERLI_RPC_URL;
const POLYGON_RPC_URL = process.env.POLYGON_RPC_URL;
const OPTIMISM_RPC_URL = process.env.OPTIMISM_RPC_URL;
const ZKSYNC_RPC_URL = process.env.ZKSYNC_RPC_URL;
const ARBITRUM_RPC_URL = process.env.ARBITRUM_RPC_URL;
const AVALANCHE_RPC_URL = process.env.AVALANCHE_RPC_URL;
const BASE_RPC_URL = process.env.BASE_RPC_URL;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    hardhat: {
      chainId: 1337
    },
    ethereum: {
      url: ETHEREUM_RPC_URL !== undefined ? ETHEREUM_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 1
    },
    avalanche: {
      url: AVALANCHE_RPC_URL !== undefined ? AVALANCHE_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 43114
    },
    ethereumSepolia: {
      url: ETHEREUM_SEPOLIA_RPC_URL !== undefined ? ETHEREUM_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 11155111
    },
    polygonMumbai: {
      url: POLYGON_MUMBAI_RPC_URL !== undefined ? POLYGON_MUMBAI_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 80001
    },
    optimismGoerli: {
      url: OPTIMISM_GOERLI_RPC_URL !== undefined ? OPTIMISM_GOERLI_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 420,
    },
    arbitrumGoerli: {
      url: ARBITRUM_GOERLI_RPC_URL !== undefined ? ARBITRUM_GOERLI_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 421613
    },
    avalancheFuji: {
      url: AVALANCHE_FUJI_RPC_URL !== undefined ? AVALANCHE_FUJI_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 43113
    },
    baseGoerli: {
      url: BASE_GOERLI_RPC_URL !== undefined ? BASE_GOERLI_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 84531
    },
    optimism: {
      url: OPTIMISM_RPC_URL !== undefined ? OPTIMISM_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 10
    },
    polygon: {
      url: POLYGON_RPC_URL !== undefined ? POLYGON_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 137
    },
    zksync: {
      url: ZKSYNC_RPC_URL !== undefined ? ZKSYNC_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 324
    },
    arbitrum: {
      url: ARBITRUM_RPC_URL !== undefined ? ARBITRUM_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 42161
    },
    base: {
      url: BASE_RPC_URL !== undefined ? BASE_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 8453
    }
  },
};

export default config;
