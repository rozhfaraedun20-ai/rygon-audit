# Rygon Audit Candidate 1 to Candidate 2 Transition & Diff Report

> **Status:** Candidate 2 Documentation Correction Pass  
> **Date:** October 2026  
> **Target Package:** `rygon-audit-candidate-2/`  

---

## 1. Executive Summary

| Verification Category | Status | Details |
| :--- | :--- | :--- |
| **CONTRACT CODE CHANGED** | **NO** | All 3 Solidity files are **100% byte-for-byte identical** to Candidate 1. |
| **DOCUMENTATION CORRECTED** | **YES** | 6 technical/reproducibility inaccuracies in specification docs corrected. |
| **TEST INVARIANTS STATUS** | **PASS** | 78/78 Hardhat tests pass with full 48-hour timelock delay rehearsal. |

---

## 2. Byte-for-Byte Contract Invariant Verification

SHA-256 cryptographic hashes for the three in-scope smart contracts:

| Contract File | Candidate 1 SHA-256 | Candidate 2 SHA-256 | Code Changed? |
| :--- | :--- | :--- | :--- |
| `contracts/Rygon.sol` | `b8accc2be01ca66fc8074606922ec7b40f0b8f9d0c9a0b61f845b383ac232e12` | `b8accc2be01ca66fc8074606922ec7b40f0b8f9d0c9a0b61f845b383ac232e12` | **NO (Identical)** |
| `contracts/RygonGovernance.sol` | `d36f8c1d43cbe520e87b038bcb99ac84bea2f1a066fe3474ea2dfb052c7279b3` | `d36f8c1d43cbe520e87b038bcb99ac84bea2f1a066fe3474ea2dfb052c7279b3` | **NO (Identical)** |
| `contracts/RygonMigrationDistributor.sol` | `17a8af76c1b601968a6aeb329f8d0c9d746fe43d16928ab6d1025302356593ee` | `17a8af76c1b601968a6aeb329f8d0c9d746fe43d16928ab6d1025302356593ee` | **NO (Identical)** |

---

## 3. Discrepancies Identified and Corrected

### Discrepancy 1: AccessControl Inheritance & Handover
- **Candidate 1 Claim:** Listed `contracts/Rygon.sol` as inheriting `AccessControl2Step` and described a two-step admin transfer (`beginDefaultAdminTransfer` / `acceptDefaultAdminTransfer`).
- **Ground Truth:** `Rygon.sol` inherits OpenZeppelin's standard `AccessControl`.
- **Candidate 2 Correction:** Corrected `README.md`, `SCOPE.md`, and `PRIVILEGED_ROLES.md` to accurately reflect standard `AccessControl` role management (`grantRole`, `revokeRole`, and `renounceRole`).

### Discrepancy 2: Migration Distributor Inheritance
- **Candidate 1 Claim:** Listed `RygonMigrationDistributor.sol` as inheriting `ReentrancyGuard`.
- **Ground Truth:** The contract inherits `Ownable` and `Pausable` (effects before interactions pattern: `_claimed[index] = true; require(token.transfer(...))`).
- **Candidate 2 Correction:** Removed all references to `ReentrancyGuard` from `README.md` and `SCOPE.md`.

### Discrepancy 3: Claim Tracking Data Structure
- **Candidate 1 Claim:** Described migration claim tracking as a "bitmap" or "bitmapped index array".
- **Ground Truth:** Implemented as `mapping(uint256 => bool) private _claimed`.
- **Candidate 2 Correction:** Corrected `ARCHITECTURE.md`, `THREAT_MODEL.md`, and `MIGRATION_MODEL.md` to accurately state "index-to-claimed boolean mapping".

### Discrepancy 4: Merkle Leaf Hash Construction
- **Candidate 1 Claim:** Stated that leaves were "double-hashed".
- **Ground Truth:** Leaf computation in `RygonMigrationDistributor.sol` is a single keccak256 hash: `keccak256(abi.encodePacked(index, account, amount))`.
- **Candidate 2 Correction:** Removed "double-hashed" claims across all documentation files (`ARCHITECTURE.md`, `MIGRATION_MODEL.md`, etc.).

### Discrepancy 5: Timelock Delay Rehearsal
- **Candidate 1 State:** Rehearsal test in `GovernanceRehearsal.test.ts` previously used `TIMELOCK_DELAY_24H = 86_400`.
- **Ground Truth Production Design:** 48 hours (`172800` seconds).
- **Candidate 2 Correction:** Updated `GovernanceRehearsal.test.ts` to test against the full 48-hour delay (`TIMELOCK_DELAY_48H = 172_800`) and updated `TEST_RESULTS.md` with the verified 48h output.

### Discrepancy 6: OpenZeppelin Dependency Version
- **Candidate 1 Claim:** Stated dependency as `@openzeppelin/contracts@5.0.2` or `@5.2.0`.
- **Ground Truth:** Exact installed version in `contracts/package-lock.json` is `5.6.1`.
- **Candidate 2 Correction:** Updated `REPRODUCIBILITY.md`, `SCOPE.md`, and `REBRAND_DIFF.md` to accurately specify `5.6.1`.
