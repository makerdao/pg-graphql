#!/usr/bin/env node

const args  = process.argv.slice(2);
const lib   = require('../lib/common');
const block = require('../libexec/block');
const gen   = 4753930;

export const run = () => {
lib.web3.eth.getBlockNumber()
  .then(to => {
    lib.db.one(lib.sql.lastBlock)
      .then(from => {
        lib.db.any(lib.sql.missingBlocks, {from: gen, to: to})
          .then(data => {
            let earliest = from.n;
            let latest   = to;
            let diff = latest-earliest;
            let info =`
            Latest Block: ${latest}
            Last Synced Block: ${earliest}
            Diff: ${diff}
            Missing: ${data.length}
            `;
            console.log(info);
            sync(earliest, latest);
            if(data.length > diff)
              syncMissing(data);
          })
          .catch(e => console.log("Web3 Error",e));
      })
      .catch(e => console.log("PG Error",e));
  })
  .catch(e => console.log("PG Error",e));
}

const syncMissing = (data) => {
  let blocks = [];
  for (var i = 0; i < data.length; i ++) {
    blocks.push(data[i]._n);
  }
  require('bluebird').map(blocks, (n) => {
    return block.sync(n);
  }, {concurrency: 50})
}

const range = (from, downTo) => {
  let a=[from], b=from;
  while(b>downTo) { b-=1; a.push(b); }
  return a;
}

const sync = (earliest, latest) => {
  let fromBlock   = args[0] || earliest;
  let toBlock     = args[1] || latest;
  let concurrency = args[2] || 50;
  batchSync(range(toBlock, fromBlock), concurrency);
}

const batchSync = (blockRange, concurrency) => {
  require('bluebird').map(blockRange, (n) => {
    return block.sync(n);
  }, {concurrency: concurrency})
}
