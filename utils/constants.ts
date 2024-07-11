export const CREATE3_ADDRESS = '0x93FEC2C00BfE902F733B57c5a6CeeD7CD1384AE1';

export const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

export const layerzeroEndpoints = {
    ethereum: {
        address: "0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675",
        chainId: 101,
        relayer: "0x902F09715B6303d4173037652FA7377e5b98089E",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    bsc: {
        address: "0x3c2269811836af69497E5F486A85D7316753cf62",
        chainId: 102,
        relayer: "0xa27a2ca24dd28ce14fb5f5844b59851f03dcf182",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    polygon: {
        address: "0x3c2269811836af69497E5F486A85D7316753cf62",
        chainId: 109,
        relayer: "0x75dc8e5f50c8221a82ca6af64af811caa983b65f",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    arbitrum: {
        address: "0x3c2269811836af69497E5F486A85D7316753cf62",
        chainId: 110,
        relayer: "0x177d36dbe2271a4ddb2ad8304d82628eb921d790",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    optimism: {
        address: "0x3c2269811836af69497E5F486A85D7316753cf62",
        chainId: 111,
        relayer: "0x81e792e5a9003cc1c8bf5569a00f34b65d75b017",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    avalanche: {
        address: "0x3c2269811836af69497E5F486A85D7316753cf62",
        chainId: 106,
        relayer: "0x81e792e5a9003cc1c8bf5569a00f34b65d75b017",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    zksync: {
        address: "0x9b896c0e23220469C7AE69cb4BbAE391eAa4C8da",
        chainId: 165,
        relayer: "0x9923573104957bf457a3c4df0e21c8b389dd43df",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    linea: {
        address: "0xb6319cC6c8c27A8F5dAF0dD3DF91EA35C4720dd7",
        chainId: 183,
        relayer: "0xA658742d33ebd2ce2F0bdFf73515Aa797Fd161D9#code",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    loot: {
        address: "0xb6319cC6c8c27A8F5dAF0dD3DF91EA35C4720dd7",
        chainId: 197,
        relayer: "0x902F09715B6303d4173037652FA7377e5b98089E",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    base: {
        address: "0xb6319cC6c8c27A8F5dAF0dD3DF91EA35C4720dd7",
        chainId: 184,
        relayer: "0xcb566e3B6934Fa77258d68ea18E931fa75e1aaAa#code",
        oracle: "0xD56e4eAb23cb81f43168F9F45211Eb027b9aC7cc"
    },
    scroll: {
        address: "0xb6319cC6c8c27A8F5dAF0dD3DF91EA35C4720dd7",
        chainId: 214
    },
    // TESTNET
    ethereumSepolia: {
        address: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
        chainId: 10161,
    },
    bscTestnet: {
        address: "0x6Fcb97553D41516Cb228ac03FdC8B9a0a9df04A1",
        chainId: 10102,
    },
    arbitrumSepolia: {
        address: "0x6098e96a28E02f27B1e6BD381f870F1C8Bd169d3",
        chainId: 10231,
    },
    optimismSepolia: {
        address: "0x55370E0fBB5f5b8dAeD978BA1c075a499eB107B8",
        chainId: 10232,
    },
    baseSepolia: {
        address: "0x55370E0fBB5f5b8dAeD978BA1c075a499eB107B8",
        chainId: 10245,
    },
    scrollSepolia: {
        address: "0x6098e96a28E02f27B1e6BD381f870F1C8Bd169d3",
        chainId: 10214,
    },
    beraTestnet: {
        address: "0x6098e96a28E02f27B1e6BD381f870F1C8Bd169d3",
        chainId: 10256
    },
    avalancheFuji: {
        address: "0x93f54D755A063cE7bB9e6Ac47Eccc8e33411d706",
        chainId: 10106
    }
}

export const supraEndpoints = {
    polygon: {
        router: "0x76606cD35d3De51d2c2e44D6eb7AF593D8dfD983",
        deposit: "0xFf4A488b0564281ADfa12b1A81168a6588D577c0"
    },
    arbitrum: {
        router: "0x7d86fbfc0701d0bf273fd550eb65be1002ed304e",
        deposit: "0xd44b6c04d0e13f80a124827882df05617fc1c0eb"
    },
    optimism: {
        router: "0x745d8beC4b46553629FF277Aad62F579CAB96DE4",
        deposit: "0x82aEdcC0D208aCE1D773E785f182db5B52d9D0cc"
    },
    base: {
        router: "0x73970504Df8290E9A508676a0fbd1B7f4Bcb7f5a",
        deposit: "0xAf2eE23d1Ff837A02D4D58c07a97561F5709fCb2"
    },
    ethereuem: {
        router: "0x23726e27Ec79d421cf58C815D37748AfCaFeC9e4",
        deposit: "0xEAc4A79C6a97c312604EAFdCCbC18171FB9c83b0"
    },
    bsc: {
        router: "0x49572e73D4001A922d3A574B3BcDf666a1167743",
        deposit: "0xa8564Fe57A0DF0D5dD83A56ff6822Ecee978d2d3"
    },
    linea: {
        router: "0x678cf2ce5beab9884d8cc49dc022f1ccd997474c",
        deposit: "0x2d0f9cf77951dfc50d091c0cce0fb634149e1fb9"
    },
    avalanche: {
        router: "0x04064A3abe03fE485E3f2Fdc97cB0BCD07170112",
        deposit: "0x97dA09C941158c231a6377BC881Fb130C053950B"
    },
    // TESTNET
    ethereumSepolia: {
        router: "0x7e0EA6e335EDA42f4c256246f62c6c3DCf4d4908",
        deposit: "0x2519D5ecE31f02995DF883CE35faDc05D9f12803"
    },
    bscTestnet: {
        router: "0xF65754b4988aD9ff25E0f2980f645A02eEB73A5D",
        deposit: "0x45dD6AB76De3c326d8296299C849791897FCffc2"
    },
    arbitrumGoerli: {
        router: "0xe0c0c4b7fe7d07fcde1a4f0959006a71c0ebe787",
        deposit: "0xd5fd8f137d718a1eb386e8c854c27612690548bb"
    },
    optimismGoerli: {
        router: "0x6D46C098996AD584c9C40D6b4771680f54cE3726",
        deposit: "0x1697F96d52DFB51CcC96856680DA885c8AdAe429"
    },
    baseGoerli: {
        router: "0xe01754DEB54c4915D65331Fa31ebf9111CacF9C2",
        deposit: "0x51a34E727001b97c26e70Bd677fc799490e781d7"
    },
    zero: {
        router: ZERO_ADDRESS,
        deposit: ZERO_ADDRESS
    }
}

export const wormholeEndpoints = {
    arbitrum: {
        relayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        chainId: 23
    },
    optimism: {
        relayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        chainId: 24
    },
    polygon: {
        relayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        chainId: 5
    },
    ethereum: {
        relayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        chainId: 2
    },
    avalanche: {
        relayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        chainId: 6
    },
    bsc: {
        relayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        chainId: 4
    },
    base: {
        relayer: "0x706f82e9bb5b0813501714ab5974216704980e31",
        chainId: 30
    },
    // TESTNET
    ethereumSepolia: {
        relayer: "0x7B1bD7a6b4E61c2a123AC6BC2cbfC614437D0470",
        chainId: 10002
    },
    bscTestnet: {
        relayer: "0x80aC94316391752A193C1c47E27D382b507c93F3",
        chainId: 4
    },
    arbitrumSepolia: {
        relayer: "0x7B1bD7a6b4E61c2a123AC6BC2cbfC614437D0470",
        chainId: 10003
    },
    optimismSepolia: {
        relayer: "0x93BAD53DDfB6132b0aC8E37f6029163E63372cEE",
        chainId: 10005
    },
    baseSepolia: {
        relayer: "0x93BAD53DDfB6132b0aC8E37f6029163E63372cEE",
        chainId: 10004
    },
    avalancheFuji: {
        relayer: "0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB",
        chainId: 6
    }
}

export const hyperlaneEndpoints = {
    // MAINNET
    arbitrum: {
        relayer: "0x979Ca5202784112f4738403dBec5D0F3B9daabB9",
        chainId: 42161,
        formatChainId: 2002,
    },
    avalanche: {
        relayer: "0xFf06aFcaABaDDd1fb08371f9ccA15D73D51FeBD6",
        chainId: 43114,
        formatChainId: 2003,
    },
    bsc: {
        relayer: "0x2971b9Aec44bE4eb673DF1B88cDB57b96eefe8a4",
        chainId: 56,
        formatChainId: 2004,
    },
    optimism: {
        relayer: "0xd4C1905BB1D26BC93DAC913e13CaCC278CdCC80D",
        chainId: 10,
        formatChainId: 2005,
    },
    polygon: {
        relayer: "0x5d934f4e2f797775e53561bB72aca21ba36B96BB",
        chainId: 137,
        formatChainId: 2006,
    },
    base: {
        relayer: "0xeA87ae93Fa0019a82A727bfd3eBd1cFCa8f64f1D",
        chainId: 8453,
        formatChainId: 2007,
    },
    scroll: {
        relayer: "0x2f2aFaE1139Ce54feFC03593FeE8AB2aDF4a85A7",
        chainId: 534352,
        formatChainId: 2008,
    },
    // TESTNET
    ethereumSepolia: {
        relayer: "0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766",
        chainId: 11155111,
        formatChainId: 10161,
    },
    bscTestnet: {
        relayer: "0xF9F6F5646F478d5ab4e20B0F910C92F1CCC9Cc6D",
        chainId: 97,
        formatChainId: 10102,
    },
    avalancheFuji: {
        relayer: "0x5b6CFf85442B851A8e6eaBd2A4E4507B5135B3B0",
        chainId: 43113,
        formatChainId: 10106,
    },
    scrollSepolia: {
        relayer: "0x3C5154a193D6e2955650f9305c8d80c18C814A68",
        chainId: 534351,
        formatChainId: 10214,
    },
}

export const vizingEndpoints = {
    // MAINNET
    arbitrum: {
        relayer: "0xD725Bc299a232201984FEcb4FF106d84E894193f",
        chainId: 42161,
        formatChainId: 3002,
    },
    optimism: {
        relayer: "0x523D8B6893D2D0Ce2B48E7964432ce19A2C641F2",
        chainId: 10,
        formatChainId: 3005,
    },
    base: {
        relayer: "0x5D77b0c9855F44a8fbEf34E670e243E988682a82",
        chainId: 8453,
        formatChainId: 3007,
    },
    scroll: {
        relayer: "0x523D8B6893D2D0Ce2B48E7964432ce19A2C641F2",
        chainId: 534352,
        formatChainId: 3008,
    },
    // TESTNET
    ethereumSepolia: {
        relayer: "0x0B5a8E5494DDE7039781af500A49E7971AE07a6b",
        chainId: 11155111,
        formatChainId: 3011,
    },
    baseSepolia: {
        relayer: "0x0B5a8E5494DDE7039781af500A49E7971AE07a6b",
        chainId: 84532,
        formatChainId: 3012,
    },
    optimismSepolia: {
        relayer: "0x4577A9D09AE42913fC7c4e0fFD87E3C60CE3bb1b",
        chainId: 11155420,
        formatChainId: 3013
    }
}