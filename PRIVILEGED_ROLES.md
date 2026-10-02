# Privileged Roles & Governance Handover — Rygon Candidate 1

## Role Definitions

| Role | Identifier | Capabilities | Intended Mainnet Holder |
| :--- | :--- | :--- | :--- |
| `DEFAULT_ADMIN_ROLE` | `0x00...00` | Grants/revokes all roles, manages contract parameters | `RygonTimelock` (governed by 3-of-5 Multisig) |
| `MINTER_ROLE` | `keccak256("MINTER_ROLE")` | Direct token minting & EIP-712 claim signing | Dedicated secure key management service / Timelock |
| `PAUSER_ROLE` | `keccak256("PAUSER_ROLE")` | Instant emergency pause & unpause | Emergency Guardian (3-of-5 Multisig + designated signers) |

---

## Governance Architecture

On Base Mainnet, all administrative capabilities are placed behind the **RygonTimelock** contract with an enforced delay of **48 hours (172,800 seconds)**:

1. **Multisig Proposer:** The 3-of-5 Gnosis Safe Multisig proposes an administrative transaction.
2. **Timelock Queue:** The operation is queued on-chain with a 48-hour delay.
3. **Public Inspection Window:** The community and auditors observe the queued operation on-chain.
4. **Execution:** After 48 hours, the operation can be executed.
5. **Cancellation:** If a malicious or buggy transaction is proposed, signers can cancel it prior to execution.

---

## Deployer EOA Role Renouncement Sequence

At mainnet deployment, the deployer EOA executes the following sequence:
1. Deploy `Rygon.sol` (Deployer has Admin and Pauser roles; zero Minter role).
2. Deploy `RygonTimelock.sol` with 48h delay, setting Multisig as Proposer/Executor.
3. Grant `DEFAULT_ADMIN_ROLE` on `Rygon.sol` to `RygonTimelock`.
4. Grant `PAUSER_ROLE` on `Rygon.sol` to Emergency Guardian.
5. Grant `MINTER_ROLE` on `Rygon.sol` to dedicated server signer (with timelock as role admin).
6. Renounce deployer's `DEFAULT_ADMIN_ROLE` on `Rygon.sol`.
7. Renounce deployer's `PAUSER_ROLE` on `Rygon.sol`.

**Result:** Zero EOA custody of administrative privileges.
