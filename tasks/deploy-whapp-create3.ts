import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment, TaskArguments } from "hardhat/types";
import { Wallet, JsonRpcProvider, AbiCoder, keccak256, toUtf8Bytes, parseEther } from "ethers";
import { getPrivateKey, getProviderRpcUrl, getWormholeEndpoints } from "../utils/helper";
import { ICREATE3Factory, ICREATE3Factory__factory, WormholeApp__factory } from "../typechain-types";
import { Spinner } from "../utils/spinner";
import { CREATE3_ADDRESS } from "../utils/constants";

task(`deploy-whapp-create3`, `Deploy WormholeApp.sol smart contract`)
    .addParam(`xeno`, `The address of XenoBunny`)
    .setAction(async (taskArguments: TaskArguments, hre: HardhatRuntimeEnvironment) => {
        const { xeno } = taskArguments;
        const privateKey = getPrivateKey();
        const rpcProviderUrl = getProviderRpcUrl(hre.network.name);

        const provider = new JsonRpcProvider(rpcProviderUrl);
        const wallet = new Wallet(privateKey);
        const deployer = wallet.connect(provider);
        const defaultCoder = new AbiCoder();

        const whEndpointAddress = getWormholeEndpoints(hre.network.name).relayer;
        const create3Contract: ICREATE3Factory = ICREATE3Factory__factory.connect(CREATE3_ADDRESS, deployer);

        const spinner: Spinner = new Spinner();

        console.log(`Attempting to deploy WormholeApp smart contract on the ${hre.network.name} blockchain using ${deployer.address} address`);
        spinner.start();

        const ccWhServerFactory: WormholeApp__factory = await hre.ethers.getContractFactory('WormholeApp') as WormholeApp__factory;
        const ccWhServerBytecode = ccWhServerFactory.bytecode;

        const ccWhServerEncodedParams = defaultCoder.encode(
            ["address", "address", "address"],
            [deployer.address, whEndpointAddress, xeno]
        );

        const ccWhServerCreationCode = ccWhServerBytecode + ccWhServerEncodedParams.slice(2);
        const ccWhServerSalt = keccak256(toUtf8Bytes("XenoWhAppV2"));
        const tx = await create3Contract.deploy(ccWhServerSalt, ccWhServerCreationCode, { gasPrice: parseEther("0.0000000001026") });
        const ccWhServerAddress = await create3Contract.getDeployed(deployer.address, ccWhServerSalt);
        console.log(`✅ WormholeApp contract deployed at address ${ccWhServerAddress} by ${tx.hash}`);

        spinner.stop();
    })