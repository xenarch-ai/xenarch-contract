# xenarch-contract

USDC splitter smart contract on Base L2. Splits incoming USDC payments between publisher and Xenarch treasury. 0% launch fee, 0.99% hard cap immutable.

## Stack

- Solidity 0.8.20, Foundry, Base L2
- Key file: `src/XenarchSplitter.sol`

## Commands

- Build: `forge build`
- Test: `forge test -vvv`
- Deploy (Sepolia): `forge script script/Deploy.s.sol --rpc-url base-sepolia --broadcast --verify`
- Deploy (Mainnet): `forge script script/Deploy.s.sol --rpc-url base-mainnet --broadcast --verify`
- Verify: `forge verify-contract <address> src/XenarchSplitter.sol:XenarchSplitter --chain base`

## Deployed Addresses

Tracked in `deployments/` directory.

## Workflow

See root `../CLAUDE.md` for branching, PR, and commit conventions.

## Architecture

See `../Information/design/smart-contract.md` for contract design.
