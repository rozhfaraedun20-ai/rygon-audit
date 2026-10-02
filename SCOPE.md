# Audit Scope — Rygon Candidate 2

## In-Scope Smart Contracts

### 1. `contracts/Rygon.sol`
- **Inheritance:** `ERC20Capped`, `ERC20Burnable`, `ERC20Pausable`, `AccessControl`, `EIP712` (OpenZeppelin)
- **Name:** Rygon
- **Symbol:** RYG
- **Decimals:** 18
- **Provisional Max Supply:** 10,000,000,000 RYG (10 Billion whole units)
- **Key Methods:**
  - `mint(address to, uint256 amount)` (Restricted to `MINTER_ROLE`)
  - `claimWithAuthorization(address to, uint256 amount, uint256 nonce, uint256 deadline, bytes calldata signature)` (Verifies EIP-712 signature from `MINTER_ROLE`)
  - `burn(uint256 value)` / `burnFrom(address account, uint256 value)`
  - `pause()` / `unpause()` (Restricted to `PAUSER_ROLE`)
  - `totalMinted()` (Cumulative lifetime mint counter)

### 2. `contracts/RygonGovernance.sol` (`RygonTimelock`)
- **Inheritance:** OpenZeppelin `TimelockController`
- **Min Delay:** 172,800 seconds (48 hours)
- **Proposers:** 3-of-5 Gnosis Safe Multisig
- **Executors:** 3-of-5 Gnosis Safe Multisig (or open execution after delay)
- **Admin:** `address(0)` (or Timelock itself)

### 3. `contracts/RygonMigrationDistributor.sol`
- **Inheritance:** OpenZeppelin `Ownable`, `Pausable`
- **Purpose:** Claims distribution for eligible Beta holders onto mainnet
- **Claim Tracking:** Index-to-claimed boolean mapping (`mapping(uint256 => bool) private _claimed`)
- **Merkle Verification:** OpenZeppelin `MerkleProof.verify` against single keccak256 leaf hash
- **Key Methods:**
  - `claimMigration(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof)`
  - `isClaimed(uint256 index)`
  - `pause()` / `unpause()`

---

## Out-of-Scope Components

- Deployed Base Sepolia Beta contracts (`0x6283...` and `0x7B72...`)
- Frontend application, PWA service worker, UI code
- Supabase Edge Functions (`sponsor-gas`, `claim-mining-rewards`)
- Third-party dependencies: OpenZeppelin Contracts v5.6.1
- Base EVM Layer 2 consensus and rollup mechanics
