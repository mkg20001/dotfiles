'use strict'

const {SRCDIR, read, write, exists, match} = require('../utils')
const dset = require('dset')
const flatten = require('flat')
const {unflatten} = flatten
const season = require('season')

module.exports = {
  export (path) {
    let out = read(SRCDIR, path)
    return out.replace(new RegExp(SRCDIR, 'g'), '$HOME')
  },
  import (path, out) {
    out = out.replace(/\$HOME/g, SRCDIR)
    return write(out + '\n', SRCDIR, path)
  },
  exists (path) {
    return exists(SRCDIR, path)
  },
  merge (local, remote) {
    remote = flatten(remote, {safe: true})

    for (const key in remote) {
      dset(local, key, remote[key])
    }

    return local
  },
  parse: season.parse,
  stringify: season.stringify,
  applyIgnore (orig, config, inv) {
    const cloned = JSON.parse(JSON.stringify(orig)) // TODO: perf

    const flat = flatten(cloned, {safe: true})

    for (const key in flat) {
      if (match(key, config, inv)) {
        delete flat[key]
      }
    }

    return unflatten(flat, {safe: true})
  }
}
