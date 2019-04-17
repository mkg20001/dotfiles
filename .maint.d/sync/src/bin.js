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

function import (el) {
  const remote = read(REMOTEDIR, el.pathRemote)
  el.module.import(el.pathLocal, remote)
}

function export (el) {
  const local = el.module.parse(el.module.export(el.pathLocal))
  const processed = applyIgnore(local, el.ignoreList)
  fs.writeFileSync(path.join(REMOTEDIR, el.pathRemote))
}

// TODO: merge

require('yargs') // eslint-disable-line
  .command('export', 'Export all dotfiles', (yargs) => yargs, (argv) => {
    config.forEach(el => export(el))
  })
  .command('import', 'Import all dotfiles', (yargs) => yargs, (argv) => {
    config.forEach(el => import(el))
  })
  .option('verbose', {
    alias: 'v',
    default: false
  })
  .demandCommand(1)
  .argv
