# RYGON AUDIT CANDIDATE 2 — NOT YET INDEPENDENTLY AUDITED

> [!WARNING]
> **PRE-MAINNET SECURITY CANDIDATE 2 — NOT YET INDEPENDENTLY AUDITED**  
> This repository contains the candidate smart contracts for **Rygon (RYG)** submitted for independent third-party security review. Candidate 2 supersedes Candidate 1 for documentation corrections; smart contract bytecode and Solidity logic are 100% byte-for-byte identical to Candidate 1. It has **NOT** yet received an independent third-party security audit.  
> **DO NOT DEPLOY TO MAINNET. DO NOT CREATE LIQUIDITY. DO NOT DEPOSIT REAL FUNDS.**

---

## Candidate Summary

- **Project / Brand:** Rygon
- **Token Symbol:** RYG
- **Audit Candidate:** Candidate 2 (`rygon-audit-candidate-2`)
- **Target Network:** Base Mainnet (EVM / Chain ID 8453)
- **Active Testnet Network:** Base Sepolia (EVM / Chain ID 84532)
- **Date:** October 2026
- **Status:** Self-Audited & Adversarially Red-Teamed; Open for Community & Independent Review

---

## Critical Token Supply Invariants

1. **Strict 10,000,000,000 RYG Lifetime Cap:**
   - The token supply is hard-capped at exactly **10,000,000,000 RYG** ($10^{10} \times 10^{18}$ wei).
   - Under **NO** circumstance can the total lifetime cumulative minted tokens exceed this value.
2. **Burn Does NOT Restore Mint Capacity:**
   - `totalMinted` is strictly monotonic non-decreasing. Burning tokens via `burn()` or `burnFrom()` reduces `totalSupply()` but does **NOT** decrement `totalMinted`.
3. **No Role Can Override the Cap:**
   - The `_mintWithCapCheck()` function reverts unconditionally if `totalMinted + amount > MAX_TOTAL_MINT_CAP`. Neither `MINTER_ROLE`, `DEFAULT_ADMIN_ROLE`, nor `TIMELOCK` can bypass this check.

---

## Deployed Testnet Contracts (Base Sepolia — Chain ID: 84532)

| Contract | Address | Compiler | Verification Status |
| :--- | :--- | :--- | :--- |
| **Rygon (ERC-20)** | `0x7B72B9DEb46ec963350dAe094702D0bDE39e27aF` | Solidity 0.8.27 | Deployed on-chain |
| **RygonTimelock (48h)** | `0xe0aC914e407C56b61E57c415BAb1bec8cc68E590` | Solidity 0.8.27 | Deployed on-chain |
| **RygonMigrationDistributor** | `0xA3E34537a3Bb2a1c6Da9aC578bA307436de1b519` | Solidity 0.8.27 | Deployed on-chain |

> **Historical Note:** The legacy beta testnet contract originally deployed under the working name **Kurd Coin (KC)** is located at `0x62832f73D2Fc5e1223a6a31b52cA2985a0130ca0`. The pre-rebrand audit candidate is permanently preserved at [rozhfaraedun20-ai/kurd-coin-audit](https://github.com/rozhfaraedun20-ai/kurd-coin-audit).

---

## Contracts in Scope

The audit scope is strictly limited to the three smart contracts located in `contracts/`:

| Contract File | Standard / Base | Core Purpose |
| :--- | :--- | :--- |
| `contracts/Rygon.sol` | OpenZeppelin ERC20, AccessControl, Pausable, EIP712 | Core utility token, 10B lifetime cap, gasless voucher claims |
| `contracts/RygonGovernance.sol` | OpenZeppelin TimelockController | 48-hour timelock delay for privileged administrative operations |
| `contracts/RygonMigrationDistributor.sol` | OpenZeppelin Ownable, Pausable, MerkleProof | Cryptographic 1:1 beta-to-mainnet migration distributor |

---

## Package Structure

- `contracts/` — Frozen Solidity source files for Rygon Audit Candidate 2 (identical to Candidate 1)
- `CANDIDATE_1_TO_2_DIFF.md` — Detailed comparison of Candidate 1 vs Candidate 2
- `SCOPE.md` — Detailed functional scope and external integrations
- `ARCHITECTURE.md` — Full system diagrams, component interactions, and data flows
- `THREAT_MODEL.md` — STRIDE-based threat analysis and attack vectors evaluated
- `SECURITY_INVARIANTS.md` — Mathematical invariants and formal test conditions
- `PRIVILEGED_ROLES.md` — AccessControl separation and 3-of-5 Multisig governance handover
- `MIGRATION_MODEL.md` — Non-double-counting 1:1 migration proof system
- `REPRODUCIBILITY.md` — Exact compiler flags, dependencies (`@openzeppelin/contracts@5.6.1`), and build verification instructions
- `TEST_RESULTS.md` — Hardhat test outputs (78/78 passing with 48h timelock rehearsal)
- `REBRAND_DIFF.md` — Line-by-line diff against the original Kurd Coin audit candidate
- `KNOWN_LIMITATIONS.md` — Explicit operational constraints, assumptions, and edge cases
- `SHA256SUMS.txt` — Cryptographic checksums of all package files

---

## Quick Reproducibility Verification

```bash
# 1. Verify cryptographic checksums
sha256sum -c SHA256SUMS.txt

# 2. In a clean Hardhat project:
npm install @openzeppelin/contracts@5.6.1
npx hardhat compile
```
For complete step-by-step reproduction instructions and automated test suites, see [`REPRODUCIBILITY.md`](REPRODUCIBILITY.md).
