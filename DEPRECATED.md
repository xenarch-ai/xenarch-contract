# DEPRECATED — xenarch-contract

**Status:** Retired 2026-04-27 (XEN-188). Repository archived (read-only).

**Deployed contract** (Base mainnet, immutable, lives forever):

- `XenarchSplitter` — [`0xC6D3a6B6fcCD6319432CDB72819cf317E88662ae`](https://basescan.org/address/0xC6D3a6B6fcCD6319432CDB72819cf317E88662ae)

The contract remains on-chain and is technically callable. **No production system uses it as of 2026-04-23.** No further development, no audits, no upgrades.

## Why retired

Xenarch pivoted to a **no-splitter, facilitator-agnostic** architecture (XEN-177 / XEN-179, decided 2026-04-22 with Andrey).

Before pivot:
- USDC payment → `XenarchSplitter.split(seller, amount)` → splits 99.01% to seller, 0.99% to Xenarch treasury
- Xenarch was in the money path with a fee-capped contract

After pivot:
- USDC payment → direct transfer to seller wallet via third-party x402 facilitator (PayAI, xpay, Ultravioleta DAO, x402.rs by default)
- Xenarch is **not** in the money path. Zero fee. No contract. No custody.
- Xenarch's role is now: spec (`pay.json`), discovery, server-side gating SDK, on-chain re-verification (no-op verifier), MCP for agents

## Where money flows now

- Direct on-chain USDC `Transfer` from agent wallet → seller wallet
- Settlement via the publisher's chosen facilitator from a ranked `facilitators[]` list in `pay.json`
- Xenarch verifies via Base RPC `eth_getLogs` against the canonical USDC Transfer event — no contract call, no custody

## References

- Architecture decision: `xenarch/Information/zero-fee-no-splitter-architecture-andrey-2026-04-22.md`
- Build sequence Phase F: `xenarch/Information/design/build-sequence.md`
- Linear: [XEN-177 (adopt no-splitter)](https://linear.app/xtro/issue/XEN-177), [XEN-179 (platform rewrite)](https://linear.app/xtro/issue/XEN-179), [XEN-188 (this retirement)](https://linear.app/xtro/issue/XEN-188)

## Unretire conditions

Reopen this repo only if Xenarch decides to re-enter the money path with a fee-bearing contract. That would reverse the core 2026-04-22 positioning ("0% fee, no contract, facilitator-agnostic"). It is not on any roadmap.
