'use strict'

const cp = require('child_process')
const minimatch = require('minimatch')
const {SRCDIR, read, write, match} = require('../shared')
const dset = require('dset')
const flatten = require('flat')
const {unflatten} = flatten
const season = require('season')

const CSON = module.exports = {
  export (path) {
    return read(SRCDIR, path)
  },
  import (path, str) {
    return write(str, SRCDIR, path)
  },
  merge (local, remote) {
    for (const key in remote) {
      dset()
    }
    for (const group in remote) {
      if (!local[group]) { local[group] = {} } // create local group if it does not exist already
      for (const key in remote[group]) {
        local[group][key] = remote[group][key] // override keys with values from remote
      }
    }

    return local
  },
  parse: season.parse,
  stringify: season.stringify,
  applyIgnore(orig, config, inv) {
    const stripped = JSON.parse(JSON.stringify(orig)) // TODO: perf

    const flat = flatten(orig, {safe: true})

    for (const key in flat) {
      if (match(key, config, inv)) {
        delete flat[key]
      }
    }

    return unflatten(orig, {safe: true})
  }
}
