# Threat Model — Rygon Candidate 1

## STRIDE Threat Analysis

| Threat Category | Potential Attack Vector | Rygon Defense Mechanism |
| :--- | :--- | :--- |
| **Spoofing** | Forged EIP-712 claims | Typed structured data (`EIP712`), domain separator binding contract address, chain ID, and strictly verifies signer has `MINTER_ROLE`. |
| **Tampering** | Altering recipient or amount in claims | Hash preimage binds `(address to, uint256 amount, uint256 nonce, uint256 deadline)`; single bit change invalidates ECDSA recovery. |
| **Repudiation** | Replay of historical claims or migration | Per-address sequential `claimNonces` on token; bitmapped index array `_claimed[index]` on distributor. |
| **Information Disclosure** | Private key leakage from client storage | WebCrypto PBKDF2-HMAC-SHA256 (600,000 iterations) + AES-GCM (256-bit). Cleartext secrets never stored in localStorage or database. |
| **Denial of Service** | Gas sponsorship depletion attack | Per-user rate limits (300s cooldown, 0.0005 ETH daily cap) + global circuit breaker (0.05 ETH 24h cap) + minimum balance checks. |
| **Elevation of Privilege** | Compromised deployer key seizing minting power | Deployer has zero minting power at deployment; admin & minter roles transferred to 48-hour Timelock governed by 3-of-5 Safe Multisig. |

---

## Supply Inflation / Burn-Remint Threat Analysis

- **Threat:** Attacker burns 1,000,000 RYG and triggers a minter key to remint 1,000,000 RYG, evading circulating supply tracking or manipulating oracle caps.
- **Defense:**
  ```solidity
  uint256 public totalMinted;
  ...
  totalMinted += amount;
  if (totalMinted > cap()) {
      revert ERC20ExceededCap(totalMinted, cap());
  }
  ```
  `totalMinted` is strictly monotonic increasing. Burning reduces `totalSupply()`, but does **NOT** decrement `totalMinted`. Reminting burned tokens beyond 10 Billion lifetime cap is impossible.
