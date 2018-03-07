const lib = require('../lib/common');
const abi = require('../abi/tub.json');
const tub = new lib.web3.eth.Contract(abi, lib.addresses.tub);

export const sync = (from, to) => {
  let options = {
    fromBlock: from,
    toBlock: to,
    filter: {sig: lib.act.cupSigs}
  }
  return tub.getPastEvents('LogNote', options)
  .then(logs => logs.forEach(log => write(log) ))
  .catch(e => console.log(e));
}

export const subscribe = () => {
  tub.events.LogNote({
    filter: { sig: lib.act.cupSigs }
  }, (e,r) => {
    if (e)
      console.log(e)
  })
  .on("data", (event) => write(event))
  .on("error", console.log);
}

const read = (log) => {
  return tub.methods.cups(log.returnValues.foo).call({}, log.blockNumber)
  .then(cup => {
    return {
      id: lib.web3.utils.hexToNumber(log.returnValues.foo),
      lad: cup.lad,
      ink: lib.u.wad(cup.ink),
      art: lib.u.wad(cup.art),
      ire: lib.u.wad(cup.ire),
      act: lib.act.cupActs[log.returnValues.sig],
      arg: lib.u.arg(log.returnValues.bar),
      block: log.blockNumber,
      tx: log.transactionHash
    }
  });
}

const write = (log) => {
  return read(log)
  .then(data => {
    lib.db.none(lib.sql.insertCup, { cup: data })
    console.log(data)
  })
  .catch(e => console.log(e));
}
