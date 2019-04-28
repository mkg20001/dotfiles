'use strict'

const {SRCDIR, MAINDIR, read, exists, match} = require('../../utils')

const yaml = require('js-yaml')
const conf = yaml.safeLoad(read(MAINDIR, 'pkg-sync.yaml'))
const modules = {}
const PKGModule = require('./module')

for (const module in conf) {
  modules[module] = PKGModule(conf[module])
}

const wrapList = (list) => {
  return {
    list,
    toString: () => list.map(String).join('\n') + '\n',
    contains: (name) => Boolean(list.filter(pkg => pkg.name === name).length),
    containsPkg: (pkg) => Boolean(list.filter(rPkg => rPkg.compare(pkg)).length)
  }
}

module.exports = (subtype) => {
  const module = modules[subtype]
  return {
    async export (path) {
      const list = await module.list()

      return wrapList(list)
    },
    async import (path, {diff}) {
      await module.remove(diff.remove.map(String))
      await module.update(diff.update.map(String))
      await module.install(diff.install.map(String))
    },
    exists (path) {
      return exists(SRCDIR, path)
    },
    merge (local, remote) {
      remote = wrapList(module.processList(remote))
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
    stringify: v => v, // v.toString() takes care of that
    applyIgnore (orig, config, inv) { // TODO: add
      return orig
    }
  }
}
