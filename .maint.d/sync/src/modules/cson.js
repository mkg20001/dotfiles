'use strict'

const cp = require('child_process')
const minimatch = require('minimatch')
const {SRCDIR, read, write, match} = require('../utils')
const dset = require('dset')
const flatten = require('flat')
const {unflatten} = flatten
const season = require('season')

const CSON = module.exports = {
  export (path) {
    let out = read(SRCDIR, path)
    return out.replace(new RegExp(SRCDIR, 'g'), '$HOME')
  },
  import (path, str) {
    out = out.replace(/\$HOME/g, SRCDIR)
    return write(str + '\n', SRCDIR, path)
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
  applyIgnore(orig, config, inv) {
    const stripped = JSON.parse(JSON.stringify(orig)) // TODO: perf

    const flat = flatten(orig, {safe: true})

    for (const key in flat) {
      if (match(key, config, inv)) {
        delete flat[key]
      }
    }

    return unflatten(flat, {safe: true})
  }
}
