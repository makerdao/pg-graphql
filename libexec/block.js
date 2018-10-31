const R   = require('ramda');
const lib = require('../lib/common');
const abi = require('../abi/med.json');
const abI = require('../abi/tub.json');
const pip = new lib.web3.eth.Contract(abi, lib.addresses.pip);
const pep = new lib.web3.eth.Contract(abi, lib.addresses.pep);
const tub = new lib.web3.eth.Contract(abI, lib.addresses.tub);

export const sync = (n) => {
  return lib.web3.eth.getBlock(n)
  .then(console.log(n))
  .then(block => write(n, block.timestamp))
}

export const subscribe = () => {
  lib.web3.eth.subscribe('newBlockHeaders', (e,r) => {
    if (e)
      console.log(e)
  })
  .on("data", (b) => write(b.number, b.timestamp))
  .on("error", console.log);
}

const write = (n, timestamp) => {
  return read(n)
  .then(val => {
    return {
      n: n,
      time: timestamp,
      pip: lib.u.wad(val[0][0]),
      pep: lib.u.wad(val[1][0]),
      per: lib.u.ray(val[2])
    }
  })
  .then(data => {
    lib.db.none(lib.sql.insertBlock, data);
    console.log(data);
  })
  .catch(e => console.log(e));
}

const read = (n) => {
  const promises = [
    pip.methods.peek().call({}, n),
    pep.methods.peek().call({}, n),
    tub.methods.per().call({}, n)
  ]
  return Promise.all(promises);
}

//-----------------------------------------------
// Sync All
//-----------------------------------------------
const concurrency = 50;
const diff = (a, b) => a - b;

export const syncMissing = () => {
  lib.latestBlock
  .then(last => { return { from: lib.genBlock, to: last }})
  .then(opts => missingBlocks(opts))
  .then(rtn => R.sort(diff, rtn.map(R.prop('n'))))
  .then(rtn => syncEach(rtn, syncMissing))
  .catch(e => console.log(e));
}

export const syncFrom = (fromBlock) => {
  priorBlocks(fromBlock)
  .then(rtn => R.sort(diff, rtn.map(R.prop('n'))))
  .then(rtn => syncEach(rtn, syncFrom))
  .catch(e => console.log(e));
}

export const syncEach = (arr, f) => {
  require('bluebird').map(arr, (n) => {
    return sync(n);
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

export const missingBlocks = (opts) => {
  let options = R.merge(opts, { limit: concurrency })
  return lib.db.any(lib.sql.missingBlocks, options )
}

const priorBlocks = (n) => {
  let options = { block: n, limit: concurrency }
  return lib.db.any(lib.sql.priorBlocks, options)
}
