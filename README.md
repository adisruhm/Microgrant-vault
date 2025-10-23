MicroGrant-Vault Smart Contract

A **decentralized grant distribution protocol** built on the **Stacks blockchain**, enabling transparent, trustless, and efficient microgrant funding. The **MicroGrant-Vault Smart Contract** allows donors to contribute STX into vaults and administrators to allocate funds to verified recipients — all on-chain, without intermediaries.

---

Overview

**MicroGrant-Vault** is designed to democratize funding by allowing anyone to:
- Create funding vaults for specific causes or projects  
- Receive STX donations from individuals or organizations  
- Distribute grants to approved beneficiaries  
- Maintain full transparency of transactions  

This system helps communities, DAOs, and projects automate and track microgrants using the **Clarity smart contract language** on Stacks.

---

Core Functionalities

| Function | Description |
|-----------|--------------|
| `create-vault` | Creates a new vault with a funding goal and administrator. |
| `donate` | Allows any user to deposit STX into a specified vault. |
| `release-grant` | Enables the vault admin to distribute funds to approved recipients. |
| `withdraw` | Allows recipients to withdraw allocated STX from their grants. |
| `get-vault` | Returns all data related to a vault including total funds, donors, and recipients. |

---

 Key Features

- **Decentralized & Transparent** — All grants and donations are verifiable on-chain.  
- **Secure Vaults** — Funds are locked in smart contracts until conditions are met.  
- **Instant Withdrawals** — Recipients can claim approved funds anytime.  
- **Clarity-Powered Logic** — Built entirely in Clarity for predictable and secure execution.  
- **Use Case Ready** — Ideal for community funding, education programs, or charity initiatives.  

---

Deployment & Testing

Prerequisites
Ensure you have:
- [Clarinet](https://github.com/hirosystems/clarinet) installed  
- A local Stacks environment configured  

Steps
```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/microgrant-vault.git

# 2. Navigate to the project directory
cd microgrant-vault

# 3. Run Clarity checks
clarinet check

# 4. Test the contract
clarinet test
