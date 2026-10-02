# Privileged Roles & Governance Handover — Rygon Candidate 3

## Role Definitions

| Role | Identifier | Capabilities | Intended Mainnet Holder |
| :--- | :--- | :--- | :--- |
| `DEFAULT_ADMIN_ROLE` | `0x00...00` | Grants/revokes all roles, manages contract parameters on `Rygon.sol` | `RygonTimelock` (governed by 3-of-5 Multisig) |
| `MINTER_ROLE` | `keccak256("MINTER_ROLE")` | Direct token minting & EIP-712 claim signing on `Rygon.sol` | Dedicated secure key management service signer / Timelock |
| `PAUSER_ROLE` | `keccak256("PAUSER_ROLE")` | Instant emergency pause & unpause on `Rygon.sol` | Emergency Guardian (3-of-5 Multisig + designated signers) |
| `owner` (Distributor) | `Ownable` | Pause/unpause claims on `RygonMigrationDistributor.sol` | `RygonTimelock` |

> **Crucial Architecture Distinction:**  
> `RygonMigrationDistributor` does **NOT** hold `MINTER_ROLE`. It holds an escrow balance of pre-funded tokens and fulfills claims via `IERC20.transfer(account, amount)`. Furthermore, `RygonMigrationDistributor` does **NOT** use `PAUSER_ROLE`; its `pause()` and `unpause()` functions are strictly restricted to its `owner` (transferred to `RygonTimelock`).

---

## Governance Architecture

On Base Mainnet, all administrative capabilities are placed behind the **RygonTimelock** contract with an enforced delay of **48 hours (172,800 seconds)**:

1. **Multisig Proposer:** The 3-of-5 Gnosis Safe Multisig proposes an administrative transaction.
2. **Timelock Queue:** The operation is queued on-chain with a 48-hour delay (`172800` seconds).
3. **Public Inspection Window:** The community and auditors observe the queued operation on-chain.
4. **Execution:** After 48 hours, the operation can be executed.
5. **Cancellation:** If a malicious or buggy transaction is proposed, signers can cancel it prior to execution.

---

## OpenZeppelin AccessControl Handover Procedure

`Rygon.sol` implements OpenZeppelin's standard `AccessControl`. At mainnet deployment, administrative handover is executed via the standard grant/revoke pattern:

1. **Deploy Token:** Deploy `Rygon.sol` (Deployer holds `DEFAULT_ADMIN_ROLE` and `PAUSER_ROLE`; zero `MINTER_ROLE`).
2. **Deploy Timelock:** Deploy `RygonTimelock.sol` with 48h delay (`172800` seconds), setting Safe Multisig as Proposer/Executor and Timelock itself as admin.
3. **Grant Admin to Timelock:** Deployer calls `rygon.grantRole(DEFAULT_ADMIN_ROLE, timelockAddress)`.
4. **Grant Operational Roles:**
   - Deployer grants `PAUSER_ROLE` on `Rygon.sol` to Emergency Guardian.
   - Deployer grants `MINTER_ROLE` on `Rygon.sol` to the dedicated backend claim signer (and optionally `RygonTimelock` for administrative batch mints within the 10B cap).
5. **Fund Distributor & Transfer Ownership:**
   - Pre-fund `RygonMigrationDistributor` with the exact verified token migration allocation via `mint()` or transfer.
   - Deployer calls `distributor.transferOwnership(timelockAddress)`.
6. **Deployer Role Renouncement:**
   - Deployer calls `rygon.renounceRole(DEFAULT_ADMIN_ROLE, deployerAddress)`.
   - Deployer calls `rygon.renounceRole(PAUSER_ROLE, deployerAddress)`.

**Result:** Zero EOA custody of administrative privileges. `RygonTimelock` becomes the sole authoritative administrator.
