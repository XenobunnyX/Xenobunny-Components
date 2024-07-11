import { HardhatUserConfig } from "hardhat/config";
import "@openzeppelin/hardhat-upgrades";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import "dotenv/config";

const PRIVATE_KEY = process.env.PRIVATE_KEY;
// MAINNET
const ETHEREUM_RPC_URL = process.env.ETHEREUM_RPC_URL;
const POLYGON_RPC_URL = process.env.POLYGON_RPC_URL;
const OPTIMISM_RPC_URL = process.env.OPTIMISM_RPC_URL;
const ZKSYNC_RPC_URL = process.env.ZKSYNC_RPC_URL;
const ARBITRUM_RPC_URL = process.env.ARBITRUM_RPC_URL;
const AVALANCHE_RPC_URL = process.env.AVALANCHE_RPC_URL;
const BASE_RPC_URL = process.env.BASE_RPC_URL;
const BSC_PRC_URL = process.env.BSC_PRC_URL;
const LINEA_RPC_URL = process.env.LINEA_RPC_URL;
const SCROLL_RPC_URL = process.env.SCROLL_RPC_URL;
const BITLAYER_RPC_URL = process.env.BITLAYER_RPC_URL;
const KROMA_RPC_URL = process.env.KROMA_RPC_URL;
// TESTNET
const SCROLL_SEPOLIA_RPC_URL = process.env.SCROLL_SEPOLIA_RPC_URL;
const BASE_SEPOLIA_RPC_URL = process.env.BASE_SEPOLIA_RPC_URL;
const ETHEREUM_SEPOLIA_RPC_URL = process.env.ETHEREUM_SEPOLIA_RPC_URL;
const OPTIMISM_SEPOLIA_RPC_URL = process.env.OPTIMISM_SEPOLIA_RPC_URL;
const ARBITRUM_SEPOLIA_RPC_URL = process.env.ARBITRUM_SEPOLIA_RPC_URL;
const BERA_TESTNET_RPC_URL = process.env.BERA_TESTNET_RPC_URL;
const BSC_TESTNET_RPC_URL = process.env.BSC_TESTNET_RPC_URL;
const LINES_SEPOLIA_RPC_URL = process.env.LINEA_SEPOLIA_RPC_URL;
const AVALANCHE_FUJI_RPC_URL = process.env.AVALANCHE_FUJI_RPC_URL;
const BITLAYER_TESTNET_RPC_URL = process.env.BITLAYER_TESTENT_RPC_URL;
const KROMA_TESTNET_RPC_URL = process.env.KROMA_TESTNET_RPC_URL;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.23",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    hardhat: {},
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
    },
    bsc: {
      url: BSC_PRC_URL !== undefined ? BSC_PRC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 56
    },
    linea: {
      url: LINEA_RPC_URL !== undefined ? LINEA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 59144
    },
    scroll: {
      url: SCROLL_RPC_URL !== undefined ? SCROLL_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 534352
    },
    bitlayer: {
      url: BITLAYER_RPC_URL !== undefined ? BITLAYER_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 200901
    },
    kroma: {
      url: KROMA_RPC_URL !== undefined ? KROMA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 255
    },
    // TESTNET
    ethereumSepolia: {
      url: ETHEREUM_SEPOLIA_RPC_URL !== undefined ? ETHEREUM_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 11155111
    },
    scrollSepolia: {
      url: SCROLL_SEPOLIA_RPC_URL !== undefined ? SCROLL_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 534351
    },
    baseSepolia: {
      url: BASE_SEPOLIA_RPC_URL !== undefined ? BASE_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 84532
    },
    optimismSepolia: {
      url: OPTIMISM_SEPOLIA_RPC_URL !== undefined ? OPTIMISM_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 11155420
    },
    arbitrumSepolia: {
      url: ARBITRUM_SEPOLIA_RPC_URL !== undefined ? ARBITRUM_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 421614
    },
    beraTestnet: {
      url: BERA_TESTNET_RPC_URL !== undefined ? BERA_TESTNET_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 80085
    },
    bscTestnet: {
      url: BSC_TESTNET_RPC_URL !== undefined ? BSC_TESTNET_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 97
    },
    lineaSepolia: {
      url: LINES_SEPOLIA_RPC_URL !== undefined ? LINES_SEPOLIA_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 59141
    },
    avalancheFuji: {
      url: AVALANCHE_FUJI_RPC_URL !== undefined ? AVALANCHE_FUJI_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 43113
    },
    bitlayerTestnet: {
      url: BITLAYER_TESTNET_RPC_URL !== undefined ? BITLAYER_TESTNET_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 200810
    },
    kromaTestnet: {
      url: KROMA_TESTNET_RPC_URL !== undefined ? KROMA_TESTNET_RPC_URL : '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId: 2358
    }
  }
};

export default config;
