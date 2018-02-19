const Web3 = require('web3');
const web3 = new Web3('wss://mainnet.infura.io/_ws');
//var web3 = new Web3(Web3.givenProvider || new Web3.providers.WebsocketProvider('ws://rpc.makerdao.com:7777'));

export default web3
