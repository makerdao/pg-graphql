const lib = require('../lib/common');
const abi = require('../abi/tub.json');
const tub = new lib.web3.eth.Contract(abi, lib.addresses.tub);

export const sync = (from, to) => {
  let options = {
    fromBlock: from,
    toBlock:   to,
    filter: {
      sig: lib.act.dict.mold
    }
  }
  tub.getPastEvents('LogNote', options)
  .then(logs => logs.forEach(log => write(log) ))
  .catch(e => console.log(e));
}

export const subscribe = () => {
  tub.events.LogNote({
    filter: { sig: lib.act.dict.mold }
  }, (e,r) => {
    if (e)
      console.log(e)
  })
  .on("data", (log) => write(log))
  .on("error", console.log);
}

const write = (log) => {
  return read(log.blockNumber)
  .then(values => {
    return {
      block: log.blockNumber,
      tx:  log.transactionHash,
      var: lib.web3.utils.hexToUtf8(log.returnValues.foo),
      arg: lib.u.wad(log.returnValues.bar),
      guy: log.returnValues.guy,
      cap: lib.u.wad(values[0]),
      mat: lib.u.ray(values[1]),
      tax: lib.u.ray(values[2]),
      fee: lib.u.ray(values[3]),
      axe: lib.u.ray(values[4]),
      gap: lib.u.wad(values[5])
    }
  })
  .then(data => {
    lib.db.none(lib.sql.insertGov, data);
    console.log(data);
  })
  .catch(e => console.log(e));

}

const read = (n) => {
  const promises = [
    tub.methods.cap().call({}, n),
    tub.methods.mat().call({}, n),
    tub.methods.tax().call({}, n),
    tub.methods.fee().call({}, n),
    tub.methods.axe().call({}, n),
    tub.methods.gap().call({}, n)
  ]
  return Promise.all(promises);
}
