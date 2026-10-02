# System Architecture — Rygon Candidate 3

## Architecture Overview

```mermaid
graph TD
    subgraph Governance & Administration
        Safe["3-of-5 Gnosis Safe Multisig"]
        Timelock["RygonTimelock (48-hour delay)"]
        Guardian["Emergency Guardian (EOA/Multisig)"]
    end

    subgraph Core Contracts
        RygonToken["Rygon ERC-20 Token\n(10B Cap, EIP-712)"]
        MigrationDistributor["RygonMigrationDistributor\n(Merkle Claims, Pre-funded)"]
    end

    subgraph Relayer Infrastructure
        ClaimSigner["Claim Distributor\n(Dedicated MINTER_ROLE Signer)"]
        GasSponsor["Gas Sponsor Relayer\n(Treasury ETH Wallet)"]
    end

    subgraph User Interaction
        UserBuiltIn["User Built-In Wallet\n(WebCrypto Encrypted Vault)"]
        UserExternal["External Wallet\n(MetaMask / Rabby)"]
    end

    Safe -->|Propose & Execute| Timelock
    Timelock -->|DEFAULT_ADMIN_ROLE| RygonToken
    Timelock -->|MINTER_ROLE Management| RygonToken
    Timelock -->|owner (Pause / Admin)| MigrationDistributor
    Guardian -->|PAUSER_ROLE (Instant Freeze)| RygonToken

    ClaimSigner -->|EIP-712 Signature| RygonToken
    MigrationDistributor -->|Token Transfers (IERC20.transfer)| RygonToken

    UserBuiltIn -->|claimWithAuthorization| RygonToken
    UserBuiltIn -->|claimMigration| MigrationDistributor
    UserExternal -->|Transfers| RygonToken

    GasSponsor -->|Gas Funding (ETH)| UserBuiltIn
```

---

## Component Responsibilities

1. **Rygon Token (`Rygon.sol`):**
   - Core value transfer unit (`RYG`).
   - Lifetime hard cap enforced at contract level (`totalMinted + amount <= cap()`).
   - Dual minting pathways: direct `mint()` for privileged administrative minting (restricted to `MINTER_ROLE`) and gasless `claimWithAuthorization()` via EIP-712 signatures from a `MINTER_ROLE` key.
   - Access control governed via OpenZeppelin `AccessControl`.
   - Emergency freeze capability via `PAUSER_ROLE`.

2. **Governance Timelock (`RygonGovernance.sol`):**
   - Decouples admin role execution from instant EOA actions using OpenZeppelin `TimelockController`.
   - Requires 48 hours (`172800` seconds) for any privileged change to take effect.
   - Acts as `DEFAULT_ADMIN_ROLE` for `Rygon.sol` and `owner` for `RygonMigrationDistributor.sol`.

3. **Migration Distributor (`RygonMigrationDistributor.sol`):**
   - Facilitates 1:1 token entitlement distribution based on the frozen beta snapshot.
   - Pre-funded with the exact migration allocation via standard `IERC20.transfer`. It does **not** have or require `MINTER_ROLE`.
   - Single keccak256 leaf hash architecture: `keccak256(abi.encodePacked(index, account, amount))`.
   - Per-index claim tracking using an index-to-claimed boolean mapping (`mapping(uint256 => bool) private _claimed`).
   - Emergency pause/unpause capability is governed by its `owner` (transferred to `RygonTimelock` in production) via OpenZeppelin `Ownable` and `Pausable`.
