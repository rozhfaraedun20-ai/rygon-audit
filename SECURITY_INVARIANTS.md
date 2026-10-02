# Security Invariants — Rygon Candidate 3

The following mathematical and state invariants must hold under all conditions, across all valid and invalid transaction sequences:

## Invariant 1: Lifetime Supply Hard Cap
$$\text{totalMinted} \le \text{cap}() = 10,000,000,000 \times 10^{18}$$
- `totalMinted` only increases on `mint()` or `claimWithAuthorization()`.
- `burn()` and `burnFrom()` decrement `totalSupply()`, but never decrement `totalMinted`.
- Exceeding the cap reverts with `"Rygon: total minted exceeds cap"`.

## Invariant 2: Conservation of Circulating Balance
$$\sum_{a \in \text{Accounts}} \text{balanceOf}(a) = \text{totalSupply}() = \text{totalMinted} - \text{totalBurned}$$
- Zero transaction fees, taxes, or reflection logic exist.
- Transfers deliver exactly $100\%$ of transferred tokens: `balanceOf(to)_new = balanceOf(to)_old + amount`.

## Invariant 3: Single-Use Claim & Replay Protection
- For any address $A$, each EIP-712 claim requires $\text{nonce} = \text{claimNonces}(A)$.
- Upon execution, $\text{claimNonces}(A)$ increments by 1.
- Re-submitting the same signature reverts with `"Rygon: invalid nonce"` or ECDSA verification failure.

## Invariant 4: Merkle Proof Exactly-Once Migration
- For any index $i$ in `RygonMigrationDistributor`:
  - Before claim: `_claimed[index] == false`.
  - After successful claim: `_claimed[index] == true`.
  - Subsequent claim with index $i$ reverts with `"Migration already claimed"`.

## Invariant 5: Emergency Pause Completeness
- When `Rygon.paused() == true`:
  - `transfer()` reverts with `EnforcedPause`.
  - `transferFrom()` reverts with `EnforcedPause`.
  - `mint()` reverts with `EnforcedPause`.
  - `claimWithAuthorization()` reverts with `EnforcedPause`.
- When `RygonMigrationDistributor.paused() == true`:
  - `claimMigration()` reverts with `EnforcedPause`.
- Emergency pause stops all asset and claim flows across Token and Distributor independently.
