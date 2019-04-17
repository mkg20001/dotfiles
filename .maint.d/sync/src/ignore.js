'use strict'

module.exports = {
  parseIgnore(str) {
    return str.split('\n').filter(Boolean).map(line => {
      let neg = line.startsWith('!')
      return {line: neg ? line.substr(1) : line, neg}
    })
  }
}
