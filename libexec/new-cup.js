const lib = require('../lib/common');
const abi = require('../abi/tub.json');
const tub = new lib.web3.eth.Contract(abi, lib.addresses.tub);

export const sync = (from, to) => {
  return tub.getPastEvents('LogNewCup', { fromBlock: from, toBlock: to })
  .then(logs => logs.forEach(log => write(log) ))
  .catch(e => console.log(e));
}

export const subscribe = () => {
  tub.events.LogNewCup({}, (e,r) => {
    if (e)
      console.log(e)
  })
  .on("data", (log) => write(log))
  .on("error", console.log);
}

const write = (log) => {
  let data = {
    id: lib.web3.utils.hexToNumber(log.returnValues.cup),
    lad: log.returnValues.lad,
    ink: 0,
    art: 0,
    ire: 0,
    act: 'open',
    arg: null,
    block: log.blockNumber,
    tx: log.transactionHash
  }
  return lib.db.none(lib.sql.insertCup, { cup: data })
  .then(() => console.log(data))
  .catch(e => console.log(e));
}
