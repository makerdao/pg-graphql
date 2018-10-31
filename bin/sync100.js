const R      = require('ramda');
const lib    = require('../lib/common');
const block  = require('../libexec/block');
const gov    = require('../libexec/gov');
const cup    = require('../libexec/cup');
const newCup = require('../libexec/new-cup');
const diff = (a, b) => a - b;

lib.latestBlock
.then(latest => {
  const earliest = latest - 100;
  console.log("Sync100", earliest, latest);
  syncBlocks(earliest, latest);
  execSync(earliest, latest);
})
.catch(e => console.log(e));

const execSync = (from, to) => {
  return cup.sync(from, to)
  .then(() => newCup.sync(from, to))
  .catch(e => console.log(e));
}

const syncBlocks = (from, to) => {
  return block.missingBlocks({from: from, to: to})
  .then(rtn => R.sort(diff, rtn.map(R.prop('n'))))
  .then(rtn => block.syncEach(rtn, syncBlocks))
  .catch(e => console.log(e));
}
