# Starknet_test
<img width="1009" alt="Screenshot 2025-03-17 at 18 38 18" src="https://github.com/user-attachments/assets/24ddc9d1-bd93-48f3-8a55-e265d962fcaa" />

The repository consists of two parts:
- <b>[SmartContract]</b> Counter contract written and tested in Cairo, build with Scarb and deployed with StarknetFoundry,
- <b>[Dapp]</b> Svelte5 frontend with StarknetKit for wallet integration and Counter contract interaction.

---

## Requirements for [SmartContract]

This repository uses [`asdf`](https://asdf-vm.com) for managing tool versions. Ensure you have `asdf` installed before proceeding.

### Tool Versions

The following tools and versions are required:

- **Scarb**: 2.9.1
- **Starknet Foundry**: 0.35.1

---

## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/KapiSolutions/starknet-test.git
   cd starknet-test
   ```

2. Install dependencies using `asdf`:

   ```bash
   asdf install
   ```

7. Build the project:

   ```bash
   scarb build
   ```

8. Run tests:
   ```bash
   scarb test
   ```

---

## Running the Example

To demonstrate the functionality, follow these steps:

1. Start a local Starknet development environment:

   ```bash
   starknet-devnet --seed 0
   ```

2. Declare and deploy contracts:

   ```bash
   sncast declare --contract-name Counter

   sncast deploy --class-hash <hash> --constructor-calldata <calldata>
   ```

3. Perform operations:

   - Get counter value:
     ```bash
     sncast call --contract-address <address> --function get_counter 
     ```
   - Increase counter:
     ```bash
     sncast invoke --contract-address <address> --function increase_counter 
     ```
   - Decrease counter:
     ```bash
     sncast invoke --contract-address <address> --function decrease_counter 
     ```
   - Set counter value:
     ```bash
     sncast invoke --contract-address <address> --function set_counter --calldata <calldata>
     ```
   - Reset counter:
     ```bash
     sncast invoke --contract-address <address> --function reset_counter 
     ```
---

## Requirements for [Dapp]
Ensure you have `Node.js` installed and [`pnpm`]([https://asdf-vm.com](https://pnpm.io/installation)) or [`npm`]([https://asdf-vm.com](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)) (or any other similiar package manager) installed before proceeding.

## Setup Instructions

1. Open terminal in `web` directory:

   ```bash
   cd web
   ```

2. Install dependencies using `pnpm` or `npm`:

   ```bash
   pnpm install
   ```
   or
    ```bash
   npm install
   ```

---

## Running the Example

1. Start dev:

   ```bash
   pnpm dev
   ```
   or
   ```bash
   npm run dev
   ```
## Dapp preview
<img width="1009" alt="Screenshot 2025-03-17 at 18 38 18" src="https://github.com/user-attachments/assets/24ddc9d1-bd93-48f3-8a55-e265d962fcaa" />
<img width="1009" alt="Screenshot 2025-03-17 at 18 26 14" src="https://github.com/user-attachments/assets/b8b0ef02-31bd-4427-b198-4f7b4a9b6447" />


