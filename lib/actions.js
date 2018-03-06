import web3 from './web3'

const sha3 = (str) => {
  return web3.utils.sha3(str).substring(0,10)
}

const dict = {
  cup: {
    give: sha3('give(bytes32,address)'),
    lock: sha3('lock(bytes32,uint256)'),
    free: sha3('free(bytes32,uint256)'),
    draw: sha3('draw(bytes32,uint256)'),
    wipe: sha3('wipe(bytes32,uint256)'),
    bite: sha3('bite(bytes32)'),
    shut: sha3('shut(bytes32)')
  },
  join: sha3('join(uint)'),
  exit: sha3('exit(uint)'),
  mold: sha3('mold(bytes32,uint256)')
}

const acts = Object.keys(dict).reduce((acc, key) => {
  acc[dict[key]] = key;
  return acc;
}, {});

const cupActs = Object.keys(dict.cup).reduce((acc, key) => {
  acc[dict.cup[key]] = key;
  return acc;
}, {});

const cupSigs = Object.values(dict.cup);

module.exports = {
  cupSigs: cupSigs,
  cupActs: cupActs,
  acts: acts,
  dict: dict
}
