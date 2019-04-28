'use strict'

const cp = require('child_process')
const minimatch = require('minimatch')
const {SRCDIR, MAINDIR, read, write, match} = require('../../utils')
const dset = require('dset')
const flatten = require('flat')
const {unflatten} = flatten
const season = require('season')

const yaml = require('js-yaml')
const conf = yaml.safeLoad(read(MAINDIR, 'pkg-sync.yaml'))
const modules = {}
const PKGModule = require('./module')

for (const module in conf) {
  modules[module] = PKGModule(conf[module])
}

module.exports = (subtype) => {
  const module = modules[subtype]
  return {
    async export (path) {
      const list = await module.list()

      return {
        list,
        toString: () => list.map(String),
        contains: (name) => Boolean(list.filter(pkg => pkg.name === name).length),
        containsPkg: (pkg) => Boolean(list.filter(rPkg => rPkg.compare(pkg)).length)
      }
    },
    async import (path, {diff, module}) {
      await module.remove(diff.remove)
      await module.update(diff.update)
      await module.install(diff.install)
    },
    merge (local, remote) {
      let notInLocal = remote.list.filter(pkg => !local.contains(pkg.name))
      let newLocal = local.list.filter(pkg => !remote.contains(pkg.name)).concat(notInLocal)

      let remove = local.list.filter(pkg => !remote.contains(pkg.name))
      let update = local.list.filter(pkg => remote.contains(pkg.name) && !remote.containsPkg(pkg))
      let install = notInLocal

      local.list = newLocal
      local.diff = {remove, update, install}

      return local
    },
    parse: v => v,
    stringify: v => v,
    applyIgnore (orig, config, inv) { // TODO: add
      return orig
    }
  }
}
