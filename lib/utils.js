import BigNumber from 'bignumber.js'
import web3 from './web3'

const tub = require('./addresses.json').ethlive.tub

let cupSlot = web3.utils.padLeft('19', 64)

const hexOffset = (hex, n) => {
  let x = new BigNumber(hex)
  let incr = x.plus(n)
  let result = '0x' + incr.toString(16)
  return result
}

const wad = (uint) => {
  return new BigNumber(uint).dividedBy(`1e18`).toNumber()
}

const timestamp = (block) => {
  return new Promise(resolve => {
    web3.eth.getBlock(block).then(blk => {
      resolve(blk.timestamp)
    })
  })
}

module.exports = {
  wad: wad,
  timestamp: timestamp
}
