import BigNumber from 'bignumber.js'
import web3 from './web3'

export const wad = (uint) => {
  return new BigNumber(uint).dividedBy(`1e18`).toNumber()
}

export const ray = (uint) => {
  return new BigNumber(uint).dividedBy(`1e27`).toNumber()
}

export const arg = (act, str) => {
  let val = '0x'+str.substring(26);
  switch (act) {
    case 'shut':
      return null;
    case 'give':
      return val;
    default:
      return wad(val);
  }
}
