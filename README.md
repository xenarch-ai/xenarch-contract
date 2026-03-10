# xenarch-contract

USDC splitter smart contract on Base L2 for the Xenarch payment network.

Splits incoming USDC payments between content publishers and Xenarch treasury. Immutable fee cap of 0.99%.

## Setup

```bash
npm install
cp .env.example .env  # add deployer private key + RPC URL
npx hardhat test
```

## Deploy

```bash
npx hardhat run scripts/deploy.js --network base-sepolia
```

## License

MIT
