'use strict'

const fs = require('fs')
const path = require('path')
const os = require('os')

const {MAINDIR, SRCDIR, REMOTEDIR, MODULES, read} = require('./shared')

const {parseConfig} = require('.')
const {parseIgnore, applyIgnore} = require('./ignore')

const config = parseConfig(read(MAINDIR, 'config')).map(el => {
  el.module = MODULES[el.type]
  if (el.ignore) {
    el.ignoreList = parseIgnore(read(MAINDIR, el.ignore))
  } else {
    el.ignoreList = []
  }
  return el
})

function dotImport (el) {
  const remote = el.module.parse(read(REMOTEDIR, el.pathRemote))
  const local = el.module.parse(el.module.export(el.pathLocal))
  el.module.merge(local, remote) // TODO: rm keys that aren't in ignore
  el.module.import(el.pathLocal, el.module.stringify(localo))
}

function dotExport (el) {
  const local = el.module.parse(el.module.export(el.pathLocal))
  const processed = el.module.applyIgnore(local, el.ignoreList)
  fs.writeFileSync(path.join(REMOTEDIR, el.pathRemote), el.module.stringify(processed))
}

// TODO: merge

require('yargs') // eslint-disable-line
  .command('export', 'Export all dotfiles', (yargs) => yargs, (argv) => {
    config.forEach(el => dotExport(el))
  })
  .command('import', 'Import all dotfiles', (yargs) => yargs, (argv) => {
    config.forEach(el => dotImport(el))
  })
  .option('verbose', {
    alias: 'v',
    default: false
  })
  .demandCommand(1)
  .argv
