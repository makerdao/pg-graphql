const lib       = require('../lib/common');

const block  = require('../libexec/block');
const newCup = require('../libexec/new-cup');
const cup    = require('../libexec/cup');
const gov    = require('../libexec/gov.js');

// Ensure that blocks are fully synced
block.syncMissing();

// Subscribe to new log events
console.log("Subscribing: blocks, cups, new cups, gov...")
block.subscribe();
gov.subscribe();
newCup.subscribe();
cup.subscribe();
