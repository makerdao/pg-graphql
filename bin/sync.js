const R      = require('ramda');
const lib    = require('../lib/common');
const block  = require('../libexec/block');
const gov    = require('../libexec/gov');
const cup    = require('../libexec/cup');
const newCup = require('../libexec/new-cup');
const step   = parseInt(process.env.BATCH) || 400;

// Backfill any blocks missing from the cache or
// Overwrite all cached blocks prior to BLOCK if
// present
if(process.env.BLOCK) {
  console.log("Syncing up to", process.env.BLOCK);
  block.syncFrom(process.env.BLOCK);
} else {
  console.log("Syncing missing blocks...");
  block.syncMissing();
}

// Get the latest block so that we can sync
// backwards to the deployment block gen.
lib.latestBlock
.then(latest => batchSync(lib.genBlock, latest))
.catch(e => console.log(e));

// Conservatively sync large ranges in batches
// to allow syncing against infura.
// Convenience & reliablility over speed.
// Tasks contained in batches run asyncronously
// batches run one at a time.
const batchSync = (earliest, latest) => {
  const batches = (to, arr=[]) => {
    arr.push({from: to-step, to: to })
    if(to < earliest-step)
      return arr;
    else
      return batches(to-step, arr);
  }
  require('bluebird').map(batches(latest).reverse(), (o) => {
    return execSync(o.from, o.to);
  }, {concurrency: 1})
  .then(() => console.log("batchSync complete"));
}

// Sync on all of the logs we're interested in
// gov events
// cup events
// new-cup events
const execSync = (from, to) => {
  return gov.sync(from, to)
  .then(() => cup.sync(from, to))
  .then(() => newCup.sync(from, to))
  .catch(e => console.log(e));
}
