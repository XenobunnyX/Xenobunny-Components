import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment, TaskArguments } from "hardhat/types";
import { Wallet, JsonRpcProvider, AbiCoder, keccak256, toUtf8Bytes } from "ethers";
import { getLzEndpoints, getPrivateKey, getProviderRpcUrl } from "../utils/helper";
import { ICREATE3Factory, ICREATE3Factory__factory, LayerzeroApp__factory } from "../typechain-types";
import { Spinner } from "../utils/spinner";
import { CREATE3_ADDRESS } from "../utils/constants";

task(`deploy-lzapp-create3`, `Deploy LayerzeroApp.sol smart contract`)
    .addParam(`xeno`, `The address of XenoBunny`)
    .setAction(async (taskArguments: TaskArguments, hre: HardhatRuntimeEnvironment) => {
        const { xeno } = taskArguments;
        const privateKey = getPrivateKey();
        const rpcProviderUrl = getProviderRpcUrl(hre.network.name);

        const provider = new JsonRpcProvider(rpcProviderUrl);
        const wallet = new Wallet(privateKey);
        const deployer = wallet.connect(provider);
        const defaultCoder = new AbiCoder();
        const create3Contract: ICREATE3Factory = ICREATE3Factory__factory.connect(CREATE3_ADDRESS, deployer);

        const lzEndpointAddress = getLzEndpoints(hre.network.name).address;
        const spinner: Spinner = new Spinner();

        console.log(`Attempting to deploy LayerzeroApp smart contract on the ${hre.network.name} blockchain using ${deployer.address} address`);
        spinner.start();

        const ccLzServerFactory: LayerzeroApp__factory = await hre.ethers.getContractFactory('LayerzeroApp') as LayerzeroApp__factory;
        const ccLzServerBytecode = ccLzServerFactory.bytecode;

        const ccLzServerEncodedParams = defaultCoder.encode(
            ["address", "address", "address"],
            [deployer.address, lzEndpointAddress, xeno]
        );

        const ccLzServerCreationCode = ccLzServerBytecode + ccLzServerEncodedParams.slice(2);
        const ccLzServerSalt = keccak256(toUtf8Bytes("XenoLzAppV1"));
        const tx1 = await create3Contract.deploy(ccLzServerSalt, ccLzServerCreationCode);
        const ccLzServerAddress = await create3Contract.getDeployed(deployer.address, ccLzServerSalt);
        console.log(`✅ LayerzeroApp contract deployed at address ${ccLzServerAddress} by ${tx1.hash}`);
 
        spinner.stop();
        console.log(`✅ LayerzeroApp contract deployed at address ${ccLzServerAddress} on the ${hre.network.name} blockchain`);
    })