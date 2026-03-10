# xenarch-contract

USDC splitter smart contract on Base L2. Splits incoming USDC payments between publisher and Xenarch treasury. 0% launch fee, 0.99% hard cap immutable.

## Stack

- Solidity 0.8.x, Hardhat, Base L2
- Key file: `contracts/XenarchSplitter.sol`

## Commands

- Test: `npx hardhat test`
- Deploy: `npx hardhat run scripts/deploy.js --network base-sepolia`
- Verify: `npx hardhat verify --network base-sepolia <address>`

## Deployed Addresses

Tracked in `deployments/` directory.

## Workflow

See root `../CLAUDE.md` for branching, PR, and commit conventions.

## Architecture

See `../Information/design/smart-contract.md` for contract design.
