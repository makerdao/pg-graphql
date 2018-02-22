#!/usr/bin/env node

import web3 from './web3'
import {db,sql} from './db'

const u = require('./utils');
const addresses = require('./addresses.json');
const actions = require('./actions.js');

const syncOptions = {
  fromBlock: web3.utils.toHex(process.env.FROM_BLOCK),
  toBlock: web3.utils.toHex(process.env.TO_BLOCK)
  //fromBlock: web3.utils.toHex(5003930),
  //toBlock: web3.utils.toHex(5004930)
}

module.exports = {
  db: db,
  sql: {
    insertCup: sql('insertCup.sql'),
    insertBlock: sql('insertBlock.sql')
  },
  web3: web3,
  addresses: addresses.ethlive,
  acts: actions,
  u: {
    wad: u.wad,
    timestamp: u.timestamp
  },
  util: {
    wad: u.wad,
    timestamp: u.timestamp
  },
  config: {
    addresses: addresses.ethlive,
    acts: actions,
  },
  options: syncOptions
}
