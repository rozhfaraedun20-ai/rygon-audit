# Migration Model — Rygon Candidate 2

## 1:1 Non-Double-Counting Migration Architecture

To migrate legitimate beta participants from Base Sepolia to Base Mainnet without double-counting, Rygon defines user entitlement as:

$$\text{Eligible Entitlement} = \text{Current On-Chain Balance} + \text{Unclaimed Claimable Mined Tokens}$$

### Why Lifetime Mined Tokens Cannot Be Used Directly:
If a user mined 10 RYG, claimed 10 RYG on-chain, and transferred 5 RYG to a merchant:
- If we counted lifetime mined tokens: User gets 10, Merchant gets 5 = 15 total (5 tokens double counted).
- Using current balance + claimable: User gets 5, Merchant gets 5 = 10 total (100% mathematical conservation).

---

## Population Segregation & Exclusion Policy

To protect the mainnet economy, the snapshot generation pipeline segregates the user population:
- **Eligible Real Users:** Fully verified real accounts with non-custodial wallets.
- **Excluded Accounts (Excluded from Snapshot):**
  - Developer initial supply / treasury addresses
  - Gas sponsor relayer wallet (`0xd072...7a8`)
  - Claim distributor backend wallet (`0x0f79...ee0`)
  - Internal QA, fuzzing, and simulation test accounts (`is_test_account = true`)
  - Burn address (`0x0000000000000000000000000000000000000000`)

---

## Merkle Leaf Construction

$$\text{leaf} = \text{keccak256}(\text{abi.encodePacked}(\text{index}, \text{account}, \text{amount}))$$

- Leaves are computed deterministically using a single `keccak256` hash over packed `(index, account, amount)`.
- Proofs are generated using sorted pair hashing to prevent branch ordering vulnerabilities.
- Verification uses OpenZeppelin `MerkleProof.verify(merkleProof, merkleRoot, leaf)`.
- Exactly-once claiming is enforced by recording the claimed index in an on-chain mapping: `mapping(uint256 => bool) private _claimed`.
