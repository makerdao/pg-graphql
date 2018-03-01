const lib = require('../lib/common');
const abi = require('../abi/med.json');
const pipMed = new lib.web3.eth.Contract(abi, lib.addresses.pip);
const pepMed = new lib.web3.eth.Contract(abi, lib.addresses.pep);

export const sync = (n) => {
  lib.web3.eth.getBlock(n)
  .then(rtn => write(n, rtn.timestamp))
  .catch(e => console.log(e));
}

export const write = (n, timestamp) => {
  console.log("Write Block:",n);
  pipMed.methods.peek().call({}, n)
  .then(pip => {
    pepMed.methods.peek().call({}, n)
    .then(pep => {
      let data = {
        n: n,
        time: timestamp,
        pip: lib.u.wad(pip[0]),
        pep: lib.u.wad(pep[0])
      }
      lib.db.none(lib.sql.insertBlock, data)
      .then(() => console.log(data))
      .catch(e => console.log(e));
    })
    .catch(e => console.log);
  })
  .catch(e => console.log);
}

const syncRange = (from, to) => {
  while(to > from) {
    to = to-1;
    sync(to);
  }
}

syncRange(process.env.FROM_BLOCK, process.env.TO_BLOCK)
