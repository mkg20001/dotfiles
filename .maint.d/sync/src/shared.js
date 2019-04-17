'use strict'

const path = require('path')
const os = require('os')
const fs = require('fs')

const MAINDIR = path.dirname(path.dirname(__dirname))
const SRCDIR = os.homedir()
const REMOTEDIR = path.dirname(MAINDIR)
const MODULES = require('./modules')
const read = (...a) => String(fs.readFileSync(path.join(...a)))

module.exports = {
  MAINDIR,
  SRCDIR,
  REMOTEDIR,
  MODULES,
  read
}
