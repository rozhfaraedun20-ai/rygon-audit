# Known Limitations & Trust Assumptions — Rygon Candidate 2

## 1. Trust Assumptions

- **Minter Key Integrity:** The `MINTER_ROLE` holder is trusted to only mint tokens according to valid off-chain session achievements and sign valid EIP-712 authorizations. If compromised, it can mint up to the remaining lifetime cap (10 Billion RYG) but cannot exceed it.
- **Relayer Availability:** Gasless transfers depend on the gas sponsorship service maintaining an active ETH balance on Base Sepolia. If the relayer is offline or drained, users can still execute standard ERC-20 transfers by funding their wallet directly with ETH.
- **Merkle Snapshot Correctness:** The migration distributor relies on the off-chain snapshot script correctly calculating `onchain + claimable` balances. Once the Merkle root is committed to `RygonMigrationDistributor`, claims are strictly deterministic and immutable.

---

## 2. Operational Constraints

- **Single Migration Snapshot:** The migration design is built around a single frozen snapshot block. Re-running the distributor with a new root requires deploying a new distributor contract.
- **Client Vault Recovery:** If a user loses their 12+ character wallet passphrase and their 12-word seed phrase, client-side encryption mathematically prevents anyone (including administrators) from recovering their private keys.
- **Timelock Delay Window:** Urgent administrative interventions (outside of Emergency Pause) are subject to the 48-hour delay (`172800` seconds). Emergency Pause can be executed immediately by the Emergency Guardian.
