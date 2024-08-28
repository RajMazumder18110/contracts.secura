# Secura (Contracts)

Secura is a decentralized application that lets users securely lock their tokens for a specified period and set future vesting schedules. It offers robust protection and flexibility, ensuring your assets are safely managed until the right time.

## Table of Contents

- [Technology](#technology)
- [Installation](#installation)
- [Usage](#usage)
- [Deployed Networks](#deployed-networks)
- [Contributing](#contributing)
- [Commit Linting](#commit-linting)

## Technology

Secura smart contracts are built using the following technologies:

- **Solidity**: The primary programming language used for writing the smart contracts.
- **Hardhat**: A development environment for compiling, deploying, testing, and debugging Ethereum-based smart contracts.
- **TypeScript**: A strongly typed programming language used for scripting and testing in the project.
- **Viem**: A library used for interacting with the Ethereum blockchain and your contracts.
- **Chai**: An assertion library used in testing to validate the contract logic.
- **Mocha**: A JavaScript test framework running on Node.js, used for running tests in the project.

## Installation

```bash
# 1. Clone the repository:
git clone https://github.com/RajMazumder18110/contracts.secura.git

# 2. Change the directory
cd contracts.secura

# 3. Install dependencies
npm install
```

## Usage

Compile the smart contracts:

```bash
npx hardhat compile
```

Deploy the contracts to a local or test network:

```bash
npx hardhat run scripts/deploy.ts --network <network-name>
```

## Deployed Networks

| Network             | Contract Address            | Explorer URL                                                             |
| ------------------- | --------------------------- | ------------------------------------------------------------------------ |
| Ethereum            | `0xYourContractAddressHere` | [Etherscan](https://etherscan.io/address/0xYourContractAddressHere)      |
| Polygon             | `0xYourContractAddressHere` | [Polygonscan](https://polygonscan.com/address/0xYourContractAddressHere) |
| Binance Smart Chain | `0xYourContractAddressHere` | [BscScan](https://bscscan.com/address/0xYourContractAddressHere)         |

## Contributing

We welcome contributions to the Secura smart contracts. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes following the commit linting rules (see below).
4. Push your branch and create a Pull Request.

## Commit Linting

This project uses [commitlint](https://commitlint.js.org/) to ensure that commit messages are consistent. The commit message should follow the pattern:

```bash
<type>(<scope>): <subject>
```

Example:

```bash
feat(contract): add token locking functionality
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `refactor`: Code refactoring without changing external behavior
- `test`: Adding or updating tests
