# React Simple Truffle Box

This simple box comes with everything you need to start using Truffle to write, compile, test, and deploy smart contracts, and interact with them from a React app.

## Installation

First ensure you are in an empty directory.

Run the `unbox` command using 1 of 2 ways.

```sh
# Install Truffle globally and run `truffle unbox`
$ npm install -g truffle
$ truffle unbox Diegoescalonaro/react-simple-truffle-box
```

```sh
# Alternatively, run `truffle unbox` via npx
$ npx truffle unbox Diegoescalonaro/react-simple-truffle-box
```

Compile and migrate the smart contracts.

```sh
$ truffle compile
$ truffle migrate
```

Run tests written in Solidity or JavaScript against your smart contracts.

```sh
$ truffle test
```

Start the react dev server.

```sh
$ cd client
$ npm start
  Starting the development server...
```

Build the application for production using the build script. A production build will be in the `dist/` folder.
```sh
$ cd client
$ npm run build
```

From there, follow the instructions on the hosted React app. It will walk you through using Truffle and Ganache to deploy the `SimpleStorage` contract, making calls to it, and sending transactions to change the contract's state.