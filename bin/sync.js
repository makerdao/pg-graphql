#!/usr/bin/env node

const args = process.argv.slice(2);
const lib = require('../lib/common');
const runner = require('../libexec/sync-Blocks');

const fromBlock = args[0] || null;
const toBlock   = args[1] || null;
const batch     = args[2] || 50;

const sync = (earliest, latest) => {
  let diff = latest-earliest;
  console.log("Latest:",latest,"Diff:",diff);
  while(latest > earliest) {
    let to   = latest;
    let from = latest-batch;
    console.log("Batch:",from,"-",to);
    runner.syncBlocks(from, to);
    latest = from;
  }
}

if(fromBlock && toBlock) {
  sync(fromBlock, toBlock);
} else {
  lib.web3.eth.getBlockNumber().then(latest => {
    lib.db.one(lib.sql.lastBlock).then(earliest => {
      sync(earliest.n, latest);
    });
  });
}

lib.web3.eth.subscribe('newBlockHeaders', (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (data) => {
  runner.writeBlock(data.number, data.timestamp);
});
