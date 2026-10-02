# Smart Contract Rebrand Diff: KurdCoin -> Rygon

> **Summary:** Comparing the frozen Kurd Coin audit candidate (`kurd-coin-audit-candidate-1`) against Rygon Audit Candidate 2 (`rygon-audit-candidate-2`).

## Protocol Logic Equivalence

The smart contract protocol logic is **100% mathematically and functionally identical**. The only modifications are cosmetic and naming updates:

| Aspect | Kurd Coin Audit Candidate | Rygon Audit Candidate 2 | Impact |
| :--- | :--- | :--- | :--- |
| **Token Name** | `Kurd Coin` | `Rygon` | Identifier only |
| **Token Symbol** | `KC` | `RYG` | Identifier only |
| **Contract Name** | `contract KurdCoin is ...` | `contract Rygon is ...` | Symbol only |
| **Timelock Name** | `contract KurdCoinTimelock` | `contract RygonTimelock` | Symbol only |
| **Distributor Name** | `contract KurdCoinMigrationDistributor` | `contract RygonMigrationDistributor` | Symbol only |
| **Lifetime Cap** | `10,000,000,000` | `10,000,000,000` | **IDENTICAL** |
| **Decimals** | `18` | `18` | **IDENTICAL** |
| **EIP-712 Struct** | `Claim(...)` | `Claim(...)` | **IDENTICAL** |
| **Error Messages** | `KurdCoin: ...` | `Rygon: ...` | String prefix only |
| **Merkle Verification** | `MerkleProof.verify` | `MerkleProof.verify` | **IDENTICAL** |
| **OpenZeppelin Version** | `v5.6.1` | `v5.6.1` | **IDENTICAL** |
| **Solidity Version** | `0.8.27` | `0.8.27` | **IDENTICAL** |

---

## Explicit Auditor Disclosure

Callisto Security (or any independent external auditor) reviewing `kurd-coin-audit` can verify that the contracts submitted in `rygon-audit-candidate-2` are the direct continuation of the reviewed logic with zero alterations to state transitions, invariant checks, or cryptographic boundaries.
