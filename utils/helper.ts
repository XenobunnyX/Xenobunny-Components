import { ZERO_ADDRESS, layerzeroEndpoints, supraEndpoints, wormholeEndpoints, hyperlaneEndpoints, vizingEndpoints } from "./constants";
import "dotenv/config";

export const getProviderRpcUrl = (network: string) => {
    let rpcUrl;
    switch (network) {
        case "ethereum":
            rpcUrl = process.env.ETHEREUM_RPC_URL;
            break;
        case "polygon":
            rpcUrl = process.env.POLYGON_RPC_URL;
            break;
        case "optimism":
            rpcUrl = process.env.OPTIMISM_RPC_URL;
            break;
        case "arbitrum":
            rpcUrl = process.env.ARBITRUM_RPC_URL;
            break;
        case "avalanche":
            rpcUrl = process.env.AVALANCHE_RPC_URL;
            break;
        case "base":
            rpcUrl = process.env.BASE_RPC_URL;
            break;
        case "scroll":
            rpcUrl = process.env.SCROLL_RPC_URL;
            break;
        case "zksync":
            rpcUrl = process.env.ZKSYNC_RPC_URL;
            break;
        case "linea":
            rpcUrl = process.env.LINEA_RPC_URL;
            break;
        case "bsc":
            rpcUrl = process.env.BSC_PRC_URL;
            break;
        case "bitlayer":
            rpcUrl = process.env.BITLAYER_RPC_URL;
            break;
        case 'kroma':
            rpcUrl = process.env.KROMA_RPC_URL;
            break;
        // TESTNET
        case "baseSepolia":
            rpcUrl = process.env.BASE_SEPOLIA_RPC_URL;
            break;
        case "ethereumSepolia":
            rpcUrl = process.env.ETHEREUM_SEPOLIA_RPC_URL;
            break;
        case "scrollSepolia":
            rpcUrl = process.env.SCROLL_SEPOLIA_RPC_URL;
            break;
        case "optimismSepolia":
            rpcUrl = process.env.OPTIMISM_SEPOLIA_RPC_URL;
            break;
        case "arbitrumSepolia":
            rpcUrl = process.env.ARBITRUM_SEPOLIA_RPC_URL;
            break;
        case "beraTestnet":
            rpcUrl = process.env.BERA_TESTNET_RPC_URL;
            break;
        case "lineaSepolia":
            rpcUrl = process.env.LINEA_SEPOLIA_RPC_URL;
            break;
        case "bscTestnet":
            rpcUrl = process.env.BSC_TESTNET_RPC_URL;
            break;
        case "avalancheFuji":
            rpcUrl = process.env.AVALANCHE_FUJI_RPC_URL;
            break;
        case "bitlayerTestnet":
            rpcUrl = process.env.BITLAYER_TESTNET_RPC_URL;
            break;
        case "kromaTestnet":
            rpcUrl = process.env.KROMA_TESTNET_RPC_URL;
            break;
        default:
            throw new Error("Unknown network: " + network);
    }

    if (!rpcUrl)
        throw new Error(
            `rpcUrl empty for network ${network} - check your environment variables`
        );

    return rpcUrl;
};

export const getPrivateKey = () => {
    const privateKey = process.env.PRIVATE_KEY;

    if (!privateKey)
        throw new Error(
            "private key not provided - check your environment variables"
        );

    return privateKey;
};


export const getLzEndpoints = (network: string) => {
    switch (network) {
        case "ethereum":
            return layerzeroEndpoints.ethereum;
        case "bsc":
            return layerzeroEndpoints.bsc;
        case "polygon":
            return layerzeroEndpoints.polygon;
        case "arbitrum":
            return layerzeroEndpoints.arbitrum;
        case "optimism":
            return layerzeroEndpoints.optimism;
        case "avalanche":
            return layerzeroEndpoints.avalanche;
        case "base":
            return layerzeroEndpoints.base;
        case "zksync":
            return layerzeroEndpoints.zksync;
        case "linea":
            return layerzeroEndpoints.linea;
        case "loot":
            return layerzeroEndpoints.loot;
        case "scroll":
            return layerzeroEndpoints.scroll;
        // TESTNET
        case "baseSepolia":
            return layerzeroEndpoints.baseSepolia;
        case "ethereumSepolia":
            return layerzeroEndpoints.ethereumSepolia;
        case "scrollSepolia":
            return layerzeroEndpoints.scrollSepolia;
        case "optimismSepolia":
            return layerzeroEndpoints.optimismSepolia;
        case "arbitrumSepolia":
            return layerzeroEndpoints.arbitrumSepolia;
        case "beraTestnet":
            return layerzeroEndpoints.beraTestnet;
        case "bscTestnet":
            return layerzeroEndpoints.bscTestnet;
        case "avalancheFuji":
            return layerzeroEndpoints.avalancheFuji;
        default:
            throw new Error("Unknown network: " + network);
    }
};


export const getSupraEndpoints = (network: string) => {
    switch (network) {
        case "polygon":
            return supraEndpoints.polygon;
        case "optimism":
            return supraEndpoints.optimism;
        case "baseGoerli":
            return supraEndpoints.baseGoerli;
        case "base":
            return supraEndpoints.base;
        case "arbitrum":
            return supraEndpoints.arbitrum;
        case "bsc":
            return supraEndpoints.bsc;
        case "ethereum":
            return supraEndpoints.ethereuem;
        case "linea":
            return supraEndpoints.linea;
        case "avalanche":
            return supraEndpoints.avalanche;
        // TESTNET
        case "ethereumSepolia":
            return supraEndpoints.ethereumSepolia;
        default:
            return supraEndpoints.zero;
    }
};

export const getWormholeEndpoints = (network: string) => {
    switch (network) {
        case "polygon":
            return wormholeEndpoints.polygon;
        case "arbitrum":
            return wormholeEndpoints.arbitrum;
        case "optimism":
            return wormholeEndpoints.optimism;
        case "avalanche":
            return wormholeEndpoints.avalanche;
        case "base":
            return wormholeEndpoints.base;
        case "ethereum":
            return wormholeEndpoints.ethereum;
        case "bsc":
            return wormholeEndpoints.bsc;
        // TESTNET
        case "ethereumSepolia":
            return wormholeEndpoints.ethereumSepolia;
        case "baseSepolia":
            return wormholeEndpoints.baseSepolia;
        case "optimismSepolia":
            return wormholeEndpoints.optimismSepolia;
        case "arbitrumSepolia":
            return wormholeEndpoints.arbitrumSepolia;
        case "bscTestnet":
            return wormholeEndpoints.bscTestnet;
        case "avalancheFuji":
            return wormholeEndpoints.avalancheFuji;
        default:
            throw new Error("Unknown network: " + network);
    }
};

export const getHyperlaneEndpoints = (network: string) => {
    switch (network) {
        //MAINNET
        case "arbitrum":
            return hyperlaneEndpoints.arbitrum;
        case "avalanche":
            return hyperlaneEndpoints.avalanche;
        case "bsc":
            return hyperlaneEndpoints.bsc;
        case "optimism":
            return hyperlaneEndpoints.optimism;
        case "polygon":
            return hyperlaneEndpoints.polygon;
        case "base":
            return hyperlaneEndpoints.base;
        case "scroll":
            return hyperlaneEndpoints.scroll;
        // TESTNET
        case "ethereumSepolia":
            return hyperlaneEndpoints.ethereumSepolia;
        case "bscTestnet":
            return hyperlaneEndpoints.bscTestnet;
        case "avalancheFuji":
            return hyperlaneEndpoints.avalancheFuji;
        case "scrollSepolia":
            return hyperlaneEndpoints.scrollSepolia;
        default:
            throw new Error("Unknown network: " + network);
    }
};


export const getVizingEndpoints = (network: string) => {
    switch (network) {
        //MAINNET
        case "arbitrum":
            return vizingEndpoints.arbitrum;
        case "optimism":
            return vizingEndpoints.optimism;
        case "base":
            return vizingEndpoints.base;
        case "scroll":
            return vizingEndpoints.scroll;
        // TESTNET
        case "ethereumSepolia":
            return vizingEndpoints.ethereumSepolia;
        case "baseSepolia":
            return vizingEndpoints.baseSepolia;
        case "optimismSepolia":
            return vizingEndpoints.optimismSepolia;
        default:
            throw new Error("Unknown network: " + network);
    }
};

export const generateRandomCodes = (numCodes: number, codeLength: number) => {
    const codes = new Set<string>();
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;

    while (codes.size < numCodes) {
        let code = '';
        for (let i = 0; i < codeLength; i++) {
            code += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        codes.add(code);
    }

    return [...codes];
}
