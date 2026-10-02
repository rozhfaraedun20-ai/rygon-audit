# System Architecture — Rygon Candidate 1

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
        MigrationDistributor["RygonMigrationDistributor\n(Merkle Root Distribution)"]
    end

    subgraph Relayer Infrastructure
        ClaimDistributor["Claim Distributor\n(Backend Signer)"]
        GasSponsor["Gas Sponsor Relayer\n(Treasury ETH Wallet)"]
    end

    subgraph User Interaction
        UserBuiltIn["User Built-In Wallet\n(WebCrypto Encrypted Vault)"]
        UserExternal["External Wallet\n(MetaMask / Rabby)"]
    end

    Safe -->|Propose & Execute| Timelock
    Timelock -->|DEFAULT_ADMIN_ROLE| RygonToken
    Timelock -->|MINTER_ROLE Management| RygonToken
    Guardian -->|PAUSER_ROLE (Instant Freeze)| RygonToken
    Guardian -->|PAUSER_ROLE (Instant Freeze)| MigrationDistributor

    ClaimDistributor -->|EIP-712 Signature| RygonToken
    MigrationDistributor -->|Token Transfers| RygonToken

    UserBuiltIn -->|claimWithAuthorization| RygonToken
    UserBuiltIn -->|claimMigration| MigrationDistributor
    UserExternal -->|Transfers| RygonToken

    GasSponsor -->|Gas Funding (ETH)| UserBuiltIn
```

---

## Component Responsibilities

1. **Rygon Token (`Rygon.sol`):**
   - Core value transfer unit (`RYG`).
   - Lifetime hard cap enforced at contract level.
   - Dual minting pathways: direct `mint()` for privileged systems (e.g. initial migration funding) and gasless `claimWithAuthorization()` via EIP-712 signatures.

2. **Governance Timelock (`RygonGovernance.sol`):**
   - Decouples admin role execution from instant EOA actions.
   - Requires 48 hours for any privileged change to take effect.

3. **Migration Distributor (`RygonMigrationDistributor.sol`):**
   - Facilitates 1:1 token entitlement distribution based on the frozen beta snapshot.
   - Double-hashed leaf architecture preventing length-extension or pre-image collisions.
