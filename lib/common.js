#!/usr/bin/env node

require('dotenv').config();

import web3 from './web3'
import {db,sql} from './db'

const utils = require('./utils');
const addresses = require('../addr.json');
const actions = require('./actions.js');
const chain = process.env.ETH_CHAIN || 'mainnet';

module.exports = {
  sql: {
    insertCup: sql('insertCup.sql'),
    insertBlock: sql('insertBlock.sql'),
    insertGov: sql('insertGov.sql'),
    priorBlocks: sql('priorBlocks.sql'),
    missingBlocks: sql('missingBlocks.sql')
  },
  db: db,
  web3: web3,
  addresses: addresses[chain],
  act: actions,
  u: utils,
  latestBlock: web3.eth.getBlockNumber(),
  genBlock: 4753930
}
