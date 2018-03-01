#!/usr/bin/env node

const args = process.argv.slice(2);
const lib = require('../lib/common');
const blockRunner = require('../libexec/sync-Blocks');
const cupRunner = require('../libexec/sync-Cups');
const abi = cupRunner.abi
const tub = cupRunner.tub;
const gen = 4753930;

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

const syncMissing = (data) => {
  let blocks = [];
  for (var i = 0; i < data.length; i ++) {
    blocks.push(data[i]._n);
  }
  require('bluebird').map(blocks, (n) => {
    return blockRunner.syncBlock(n);
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
    return blockRunner.syncBlock(n);
  }, {concurrency: concurrency})
}

// --------------------------------------------------------
// Subscribe - Blocks
// --------------------------------------------------------

lib.web3.eth.subscribe('newBlockHeaders', (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (data) => {
  blockRunner.writeBlock(data.number, data.timestamp);
});

// --------------------------------------------------------
// Subscribe - Cup Logs
// --------------------------------------------------------

tub.events.LogNote({
  filter: { sig: lib.acts.sigs }
}, (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (event) => {
  cupRunner.writeCup(event);
})
.on("error", console.log);

// --------------------------------------------------------
// Subscribe - New Cups
// --------------------------------------------------------

tub.events.LogNewCup({}, (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (event) => {
  newCupRunner.writeNewCup(event);
})
.on("error", console.log);
