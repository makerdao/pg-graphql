const lib = require('../lib/common');
const abi = require('../abi/med.json');
const abI = require('../abi/tub.json').abi;
const pip = new lib.web3.eth.Contract(abi, lib.addresses.pip);
const pep = new lib.web3.eth.Contract(abi, lib.addresses.pep);
const tub = new lib.web3.eth.Contract(abI, lib.addresses.tub);

export const sync = (n) => {
  lib.web3.eth.getBlock(n)
  .then(rtn => write(n, rtn.timestamp))
  .catch(e => console.log(e));
}

export const write = (n, timestamp) => {
  console.log("Write Block:",n);
  fetch(n).then(values => {
    let data = {
      n: n,
      time: timestamp,
      pip: lib.u.wad(values[0][0]),
      pep: lib.u.wad(values[1][0]),
      per: lib.u.wad(values[2])
    }
    console.log(data);
    lib.db.none(lib.sql.insertBlock, data)
      .then(() => console.log(data))
      .catch(e => console.log(e));
  })
  .catch(e => console.log(e));
}

const fetch = (n) => {
  const promises = [
    pip.methods.peek().call({}, n),
    pep.methods.peek().call({}, n),
    tub.methods.per().call({}, n)
  ]
  return Promise.all(promises);
}

const syncRange = (from, to) => {
  while(to > from) {
    to = to-1;
    sync(to);
  }
}

syncRange(process.env.FROM_BLOCK, process.env.TO_BLOCK)
