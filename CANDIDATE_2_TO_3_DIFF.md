# Rygon Audit Candidate 2 to Candidate 3 Transition & Diff Report

> **Status:** Candidate 3 Final Documentation Fact-Check Pass  
> **Date:** October 2026  
> **Target Package:** `rygon-audit-candidate-3/`  

---

## 1. Executive Summary

| Verification Category | Status | Details |
| :--- | :--- | :--- |
| **CONTRACT CODE CHANGED** | **NO** | All 3 Solidity files are **100% byte-for-byte identical** to Candidate 1 and Candidate 2. |
| **DOCUMENTATION CORRECTED** | **YES** | 5 specific technical & architectural descriptions aligned strictly with Solidity ground truth. |
| **TEST INVARIANTS STATUS** | **PASS** | 78/78 Hardhat tests pass with full 48-hour timelock delay rehearsal. |

---

## 2. Byte-for-Byte Contract Invariant Verification

SHA-256 cryptographic hashes for the three in-scope smart contracts across all candidates:

| Contract File | Candidate 1 SHA-256 | Candidate 2 SHA-256 | Candidate 3 SHA-256 | Code Changed? |
| :--- | :--- | :--- | :--- | :--- |
| `contracts/Rygon.sol` | `b8accc2be01ca66fc8074606922ec7b40f0b8f9d0c9a0b61f845b383ac232e12` | `b8accc2be01ca66fc8074606922ec7b40f0b8f9d0c9a0b61f845b383ac232e12` | `b8accc2be01ca66fc8074606922ec7b40f0b8f9d0c9a0b61f845b383ac232e12` | **NO (Identical)** |
| `contracts/RygonGovernance.sol` | `d36f8c1d43cbe520e87b038bcb99ac84bea2f1a066fe3474ea2dfb052c7279b3` | `d36f8c1d43cbe520e87b038bcb99ac84bea2f1a066fe3474ea2dfb052c7279b3` | `d36f8c1d43cbe520e87b038bcb99ac84bea2f1a066fe3474ea2dfb052c7279b3` | **NO (Identical)** |
| `contracts/RygonMigrationDistributor.sol` | `17a8af76c1b601968a6aeb329f8d0c9d746fe43d16928ab6d1025302356593ee` | `17a8af76c1b601968a6aeb329f8d0c9d746fe43d16928ab6d1025302356593ee` | `17a8af76c1b601968a6aeb329f8d0c9d746fe43d16928ab6d1025302356593ee` | **NO (Identical)** |

---

## 3. Discrepancies Corrected in Candidate 3

### Discrepancy 1: Cap Logic Description in README & Invariants
- **Candidate 2 Inaccuracy:** Referenced non-existent internal helper `_mintWithCapCheck()` and invented constant `MAX_TOTAL_MINT_CAP`.
- **Ground Truth:** In `Rygon.sol`, cap enforcement is directly written in both `mint()` and `claimWithAuthorization()`:
  ```solidity
  require(totalMinted + amount <= cap(), "Rygon: total minted exceeds cap");
  ```
  followed by `totalMinted += amount;` and `_mint(to, amount);`.
- **Candidate 3 Correction:** Updated `README.md`, `THREAT_MODEL.md`, and `SECURITY_INVARIANTS.md` to reference the exact Solidity check and error string.

### Discrepancy 2: Migration Distributor Pause Authority
- **Candidate 2 Inaccuracy:** `ARCHITECTURE.md` depicted an arrow `Guardian -->|PAUSER_ROLE (Instant Freeze)| MigrationDistributor`.
- **Ground Truth:** `RygonMigrationDistributor.sol` inherits OpenZeppelin `Ownable, Pausable`. It has **no** `PAUSER_ROLE`; `pause()` and `unpause()` are strictly `onlyOwner`.
- **Candidate 3 Correction:** Updated `ARCHITECTURE.md`, `SCOPE.md`, `SECURITY_INVARIANTS.md`, and `PRIVILEGED_ROLES.md` to clarify that distributor pause/unpause belongs to its `owner` (transferred to `RygonTimelock`).

### Discrepancy 3: Minter Role Allocation to Migration Distributor
- **Candidate 2 Inaccuracy:** `PRIVILEGED_ROLES.md` stated: *"Deployer grants MINTER_ROLE on Rygon.sol to RygonMigrationDistributor"*.
- **Ground Truth:** `RygonMigrationDistributor` does **not** have or require `MINTER_ROLE`. It distributes pre-funded tokens via `token.transfer(account, amount)`.
- **Candidate 3 Correction:** Corrected `PRIVILEGED_ROLES.md`, `ARCHITECTURE.md`, and `SCOPE.md` to state that the distributor holds an escrow balance of pre-funded tokens and does not mint.

### Discrepancy 4: Threat Model Role Handover Wording
- **Candidate 2 Inaccuracy:** `THREAT_MODEL.md` claimed *"admin & minter roles transferred to 48-hour Timelock"*.
- **Ground Truth:** `DEFAULT_ADMIN_ROLE` is transferred to Timelock, but operational daily `MINTER_ROLE` is held by a dedicated secured backend signer for EIP-712 claims.
- **Candidate 3 Correction:** Clarified trust assumption in `THREAT_MODEL.md` and `PRIVILEGED_ROLES.md`: Timelock administers the role; dedicated backend signer holds `MINTER_ROLE` for daily claim signatures (compromise can mint up to remaining cap, but never beyond 10B).

### Discrepancy 5: Threat Model Pseudocode vs Solidity
- **Candidate 2 Inaccuracy:** `THREAT_MODEL.md` used custom pseudocode `if (totalMinted > cap()) revert ERC20ExceededCap(...)`.
- **Ground Truth:** `require(totalMinted + amount <= cap(), "Rygon: total minted exceeds cap")`.
- **Candidate 3 Correction:** Replaced pseudocode with exact Solidity implementation from `Rygon.sol`.
