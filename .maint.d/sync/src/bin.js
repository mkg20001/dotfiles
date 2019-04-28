'use strict'

const fs = require('fs')
const path = require('path')
const os = require('os')

const {MAINDIR, SRCDIR, REMOTEDIR, read} = require('./utils')
const MODULES = require('./modules')

const {parseConfig} = require('.')
const {parseIgnore, applyIgnore} = require('./ignore')

const config = parseConfig(read(MAINDIR, 'config')).map(el => {
  let [type, subtype] = el.type.split(':')
  el.module = subtype ? MODULES[type](subtype) : MODULES[type]
  if (el.ignore) {
    el.ignoreList = parseIgnore(read(MAINDIR, el.ignore))
  } else {
    el.ignoreList = []
  }
  return el
})

async function dotImport (el) {
  const remote = await el.module.parse(read(REMOTEDIR, el.pathRemote))
  const local = await el.module.parse(await el.module.export(el.pathLocal))
  const localIgnored = el.module.applyIgnore(local, el.ignoreList, true) // only keep the ignored keys, others will be removed as needed
  el.module.merge(localIgnored, remote)
  await el.module.import(el.pathLocal, await el.module.stringify(localIgnored))
}

async function dotExport (el) {
  const local = await el.module.parse(await el.module.export(el.pathLocal))
  const processed = el.module.applyIgnore(local, el.ignoreList)
  fs.writeFileSync(path.join(REMOTEDIR, el.pathRemote), await el.module.stringify(processed))
}

// TODO: merge

require('yargs') // eslint-disable-line
  .command('export', 'Export all dotfiles', (yargs) => yargs, async (argv) => {
    await Promise.all(config.map(el => dotExport(el)))
  })
  .command('import', 'Import all dotfiles', (yargs) => yargs, async (argv) => {
    await Promise.all(config.map(el => dotImport(el)))
  })
  .option('verbose', {
    alias: 'v',
    default: false
  })
  .demandCommand(1)
  .argv
