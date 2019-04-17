'use strict'

const path = require('path')
const os = require('os')
const fs = require('fs')
const minimatch = require('minimatch')

const MAINDIR = path.dirname(path.dirname(__dirname))
const SRCDIR = os.homedir()
const REMOTEDIR = path.dirname(MAINDIR)
const read = (...a) => String(fs.readFileSync(path.join(...a)))
const write = (content, ...a) => fs.writeFileSync(path.join(...a), content)

const match = (id, config, inv) => { // TODO: recursive nodel&del
  let del = Boolean(config.filter(m => !m.neg && minimatch(id, m.line)).length)
  let nodel = Boolean(config.filter(m => m.neg && minimatch(id, m.line)).length)

  let out = del && !nodel
  if (inv) { out = !out } // inverse result
  return out
}

module.exports = {
  MAINDIR,
  SRCDIR,
  REMOTEDIR,
  read,
  match
}
