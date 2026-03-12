# xenarch-contract

USDC splitter smart contract on Base L2 for the Xenarch payment network.

Splits incoming USDC payments between content publishers and Xenarch treasury. Immutable fee cap of 0.99%.

## Setup

```bash
# Install Foundry (https://getfoundry.sh)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Build
forge build

# Test
forge test -vvv
```

## Deploy

```bash
cp .env.example .env  # add deployer private key, RPC URLs, USDC + treasury addresses
forge script script/Deploy.s.sol --rpc-url base-sepolia --broadcast --verify
```

## License

MIT
