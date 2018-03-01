const lib   = require('../lib/common');
const block = require('../libexec/block');
const cup   = require('../libexec/cup');
const sync  = require('../bin/sync.js');
const tub   = cup.tub;

sync.run();

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
  filter: { sig: lib.acts.sigs }
}, (e,r) => {
  if (e)
    console.log(e)
})
.on("data", (event) => {
  cup.update(event);
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
  cup.write(event);
})
.on("error", console.log);
