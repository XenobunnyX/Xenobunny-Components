import { ZERO_ADDRESS, layerzeroEndpoints, supraEndpoints, wormholeEndpoints } from "./constants";
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
        case "ethereumSepolia":
            rpcUrl = process.env.ETHEREUM_SEPOLIA_RPC_URL;
            break;
        case "optimismGoerli":
            rpcUrl = process.env.OPTIMISM_GOERLI_RPC_URL;
            break;
        case "arbitrumGoerli":
            rpcUrl = process.env.ARBITRUM_GOERLI_RPC_URL;
            break;
        case "polygonMumbai":
            rpcUrl = process.env.POLYGON_MUMBAI_RPC_URL;
            break;
        case "baseGoerli":
            rpcUrl = process.env.BASE_GOERLI_RPC_URL;
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
        case "loot":
            return layerzeroEndpoints.loot;
        case "linea":
            return layerzeroEndpoints.linea;
        case "base":
            return layerzeroEndpoints.base;
        case "ethereumSepolia":
            return layerzeroEndpoints.ethereumSepolia;
        case "optimismGoerli":
            return layerzeroEndpoints.optimismGoerli;
        case "arbitrumGoerli":
            return layerzeroEndpoints.arbitrumGoerli;
        case "polygonMumbai":
            return layerzeroEndpoints.polygonMumbai;
        case "baseGoerli":
            return layerzeroEndpoints.baseGoerli;
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
        case "ethereumSepolia":
            return supraEndpoints.ethereumSepolia;
        case "optimismGoerli":
            return supraEndpoints.optimismGoerli;
        case "arbitrumGoerli":
            return supraEndpoints.arbitrumGoerli;
        case "polygonMumbai":
            return supraEndpoints.polygonMumbai;
        case "baseGoerli":
            return supraEndpoints.baseGoerli;
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
        case "ethereumGoerli":
            return wormholeEndpoints.ethereumGoerli;
        case "optimismGoerli":
            return wormholeEndpoints.optimismGoerli;
        case "arbitrumGoerli":
            return wormholeEndpoints.arbitrumGoerli;
        case "polygonMumbai":
            return wormholeEndpoints.polygonMumbai;
        case "baseGoerli":
            return wormholeEndpoints.baseGoerli;
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
