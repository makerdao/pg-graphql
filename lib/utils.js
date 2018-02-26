import BigNumber from 'bignumber.js'
import web3 from './web3'

const tub = require('./addresses.json').ethlive.tub

const wad = (uint) => {
  return new BigNumber(uint).dividedBy(`1e18`).toNumber()
}

const arg = (str) => {
  let val = '0x'+str.substring(26);
  switch (val) {
    case '0x0000000000000000000000000000000000000000':
      return null;
    case web3.utils.isAddress(val):
      return val;
    default:
      return wad(val);
  }
}

module.exports = {
  wad: wad,
  arg: arg
}
