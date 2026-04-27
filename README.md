> **⚠️ DEPRECATED — see [DEPRECATED.md](./DEPRECATED.md)**
>
> This repository was retired on 2026-04-27 (XEN-188). Xenarch pivoted to a no-splitter, facilitator-agnostic architecture: payments now flow directly to seller wallets via third-party x402 facilitators (PayAI, xpay, Ultravioleta DAO, x402.rs). Xenarch is no longer in the money path. Zero fee. No contract.
>
> The deployed contract `0xC6D3a6B6fcCD6319432CDB72819cf317E88662ae` on Base mainnet remains on-chain (immutable) but is unused by any production system. No further development.

---

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
