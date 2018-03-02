const lib = require('../lib/common');
const abi = require('../abi/med.json');
const abI = require('../abi/tub.json').abi;
const pip = new lib.web3.eth.Contract(abi, lib.addresses.pip);
const pep = new lib.web3.eth.Contract(abi, lib.addresses.pep);
const tub = new lib.web3.eth.Contract(abI, lib.addresses.tub);

export const sync = (n) => {
  return lib.web3.eth.getBlock(n)
  .then(block => write(n, block.timestamp))
}

export const write = (n, timestamp) => {
  return fetch(n)
  .then(val => {
    return {
      n: n,
      time: timestamp,
      pip: lib.u.wad(val[0][0]),
      pep: lib.u.wad(val[1][0]),
      per: lib.u.wad(val[2])
    }
  })
  .then(data => {
    lib.db.none(lib.sql.insertBlock, data);
    console.log(data);
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
