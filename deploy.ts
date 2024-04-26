// Dependencies
import { ethers } from 'ethers';

// Replace with your Base testnet provider URL
const providerUrl = 'https://rpc.testnet.base.com/';

// Contract details (modify these)
const tokenName = 'NexTouchToken';
const tokenSymbol = 'NTK';
const totalSupply = '1000000000000000000'; // 100 billion tokens (modify decimals for adjustment)
const decimals = 18;

async function deployContract() {
    try {
        // Create a provider instance
        const provider = new ethers.JsonRpcProvider(providerUrl);//

        // Create a wallet instance with a private key
        const privateKey = ''; // Add your private key here
        const wallet = new ethers.Wallet(privateKey, provider);

        console.log('Fetching ETH balance before deployment...');
        const balanceBefore = await provider.getBalance(wallet.address);
        console.log(`Balance before: ${ethers.formatEther(balanceBefore)} ETH`);

        // Compile the contract
        const contractFactory = new ethers.ContractFactory(
            ['/* ERC20 ABI goes here */'], // Replace with actual ABI
            '/* ERC20 bytecode goes here */', // Replace with actual bytecode
            wallet
        );

        // Deploy the contract
        const contract = await contractFactory.deploy(tokenName, tokenSymbol, totalSupply, decimals);
        await contract.deployed();

        console.log(`Contract deployed at: ${contract.address}`);

        // Fetch the transaction hash
        const txHash = contract.deployTransaction.hash;

        // Get the Base scanner URL (replace with the actual URL)
        const scannerUrl = `https://blockexplorer.base.com/tx/${txHash}`;

        console.log(`Transaction hash: ${txHash}`);
        console.log(`See transaction on scanner: ${scannerUrl}`);

        console.log('Fetching ETH balance after deployment...');
        const balanceAfter = await provider.getBalance(wallet.address);
        console.log(`Balance after: ${ethers.formatEther(balanceAfter)} ETH`);
    } catch (error) {
        throw new Error(`Error during contract deployment: ${error}`);
    }
}

async function main() {
    try {
        await deployContract();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
}

main();
