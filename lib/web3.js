require('dotenv').config();

const conn = process.env.ETH_URL || 'wss://mainnet.infura.io/_ws';
const Web3 = require('web3');
const web3 = new Web3(conn);

export default web3
