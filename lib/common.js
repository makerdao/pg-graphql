#!/usr/bin/env node

import web3 from './web3'
import {db,sql} from './db'

const u = require('./utils');
const adresses = require('./addresses.json');
const actions = require('./actions.js');

module.exports = {
  db: db,
  sql: {
    insert: sql('insertCup.sql')
  },
  web3: web3,
  adresses: adresses.ethlive,
  acts: actions
}
