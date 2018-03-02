const sync = require('../libexec/sync-blocks');

if(process.env.BLOCK) {
  console.log("Re-syncing cached blocks");
  sync.resync(process.env.BLOCK);
} else {
  console.log("Syncing missing blocks");
  sync.sync();
}
