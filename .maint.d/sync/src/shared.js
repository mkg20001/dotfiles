'use strict'

const MAINDIR = path.dirname(__dirname)
const SRCDIR = os.getHome()
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
