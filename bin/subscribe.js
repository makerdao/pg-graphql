const lib   = require('../lib/common');
const block = require('../libexec/block');
const cup   = require('../libexec/cup');
const sync  = require('../libexec/sync-blocks.js');
const gov   = require('../libexec/gov.js');
const tub   = cup.tub;

sync.sync();

// --------------------------------------------------------
// Subscribe - Blocks
// --------------------------------------------------------

lib.web3.eth.subscribe('newBlockHeaders', (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (data) => {
  block.write(data.number, data.timestamp);
});

// --------------------------------------------------------
// Subscribe - Cup Logs
// --------------------------------------------------------

tub.events.LogNote({
  filter: { sig: lib.act.cupSigs }
}, (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (event) => cup.update(event))
.on("error", console.log);

// --------------------------------------------------------
// Subscribe - New Cups
// --------------------------------------------------------

tub.events.LogNewCup({}, (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (event) => cup.write(event))
.on("error", console.log);

// --------------------------------------------------------
// Subscribe - Gov Events
// --------------------------------------------------------

const genBlock = 4753930;

lib.web3.eth.getBlockNumber()
.then(latest => {

  gov.sync(genBlock, latest);
  gov.subscribe();

})
.catch(e => console.log(e));
