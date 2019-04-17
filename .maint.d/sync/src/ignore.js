'use strict'

const minimatch = require('minimatch')

module.exports = {
  parseIgnore(str) {
    return str.split('\n').filter(Boolean).map(line => {
      let neg = line.startsWith('!')
      return {line: neg ? line.substr(1) : line, neg}
    })
  },
  applyIgnore(orig, config) {
    const stripped = JSON.parse(JSON.stringify(orig)) // TODO: perf

    for (const group in stripped) {
      for (const key in stripped[group]) {
        let id = `${group}@${key}`
        let del = Boolean(strip.filter(m => !m.neg && minimatch(id, m.line)).length)
        let nodel = Boolean(strip.filter(m => m.neg && minimatch(id, m.line)).length)
        if (del && !nodel) {
          console.log('DEL', group, key)
          delete stripped[group][key]
        }
      }

      if (!Object.keys(stripped[group]).length) {
        delete stripped[group]
      }
    }

    return stripped
  }
}
