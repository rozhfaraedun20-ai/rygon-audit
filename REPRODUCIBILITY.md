# Reproducibility Guide — Rygon Candidate 1

## Build Environment

- **Node.js:** v20+ or v22+
- **Package Manager:** npm v10+
- **Hardhat:** v2.22.19
- **Solidity Compiler:** 0.8.27
- **EVM Target:** cancun
- **Optimizer:** Enabled (200 runs)

---

## Step-by-Step Compilation & Verification

1. **Clone & Install:**
   ```bash
   git clone https://github.com/rozhfaraedun20-ai/kurd-coin-dev.git
   cd "kurd-coin-dev/contracts"
   npm ci
   ```

2. **Compile Smart Contracts:**
   ```bash
   npx hardhat compile
   ```
   Expected output: `Compiled 4 Solidity files successfully (evm target: cancun).`

3. **Execute Full Test Suite (78 Tests):**
   ```bash
   npx hardhat test
   ```
   Expected output: `78 passing`

4. **Verify SHA-256 Checksums:**
   ```bash
   sha256sum -c SHA256SUMS.txt
   ```
