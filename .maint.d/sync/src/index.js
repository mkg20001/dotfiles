'use strict'

module.exports = {
  parseConfig (str) {
    return str.split('\n').map(filter).map(str => {
      let out = {}

      str.split(' ').map(str => {
        let [key, ...val] = str.split('=')
        return {key, val: val.join('=')}
      }).forEach(({key, val}) => (out[key] = val))

      return out
    })
  }
}
