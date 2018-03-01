#!/usr/bin/env node

import web3 from './web3'
import {db,sql} from './db'

const utils = require('./utils');
const addresses = require('../addr.json');
const actions = require('./actions.js');

module.exports = {
  sql: {
    insertCup: sql('insertCup.sql'),
    insertBlock: sql('insertBlock.sql'),
    lastBlock: sql('lastBlock.sql'),
    missingBlocks: sql('missingBlocks.sql')
  },
  db: db,
  web3: web3,
  addresses: addresses.ethlive,
  acts: actions,
  u: utils
}
