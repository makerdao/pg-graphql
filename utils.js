import BigNumber from 'bignumber.js'
import web3 from './config/web3'

export const sig = (str) => {
  return web3.utils.sha3(str).substring(0,10)
}

export const wad = (uint) => {
  return new BigNumber(uint).dividedBy(`1e18`).toNumber()
}
