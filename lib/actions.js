import web3 from './web3'

const sha3 = (str) => {
  return web3.utils.sha3(str).substring(0,10)
}

const dict = {
  join: sha3('join(uint)'),
  exit: sha3('exit(uint)'),
  give: sha3('give(bytes32,address)'),
  lock: sha3('lock(bytes32,uint256)'),
  free: sha3('free(bytes32,uint256)'),
  draw: sha3('draw(bytes32,uint256)'),
  wipe: sha3('wipe(bytes32,uint256)'),
  bite: sha3('bite(bytes32)'),
  shut: sha3('shut(bytes32)')
}

const acts = Object.keys(dict).reduce((acc, key) => {
  acc[dict[key]] = key;
  return acc;
}, {});

const sigs = Object.values(dict);

module.exports = {
  sigs: sigs,
  acts: acts
}
