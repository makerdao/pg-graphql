const R     = require('ramda');
const lib   = require('../lib/common');
const block = require('../libexec/block');

const gen         = 4753930;
const concurrency = 100;
const diff = (a, b) => a - b;
const lastBlock = lib.web3.eth.getBlockNumber();

export const sync = () => {
  lastBlock
  .then(last => { return { from: gen, to: last }})
  .then(opts => missingBlocks(opts))
  .then(rtn => R.sort(diff, rtn.map(R.prop('n'))))
  .then(rtn => syncEach(rtn, sync))
  .catch(e => console.log(e));
}

export const resync = (fromBlock) => {
  priorBlocks(fromBlock)
  .then(rtn => R.sort(diff, rtn.map(R.prop('n'))))
  .then(rtn => syncEach(rtn, resync))
  .catch(e => console.log(e));
}

const missingBlocks = (opts) => {
  let options = R.merge(opts, { limit: concurrency })
  return lib.db.any(lib.sql.missingBlocks, options )
}

const priorBlocks = (n) => {
  let options = { block: n, limit: concurrency }
  return lib.db.any(lib.sql.priorBlocks, options)
}

const syncEach = (arr, f) => {
  require('bluebird').map(arr, (n) => {
    return block.sync(n);
  }, {concurrency: concurrency})
  .then(() => {
    if(R.isEmpty(arr)) {
      console.log('Block sync complete');
    } else {
      console.log(`Synced: ${arr[0]} - ${arr[arr.length-1]}`)
      f(arr[0]);
    }
  });
}
