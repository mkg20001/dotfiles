'use strict'

const path = require('path')
const os = require('os')
const fs = require('fs')
const minimatch = require('minimatch')

const cp = require('child_process')
const bl = require('bl')

function spawn (cmd, args, opt, pFnc) {
  return new Promise((resolve, reject) => {
    console.log('$'.yellow.bold + ' ' + [cmd].concat(args).join(' ').blue.bold) // eslint-disable-line no-console
    const p = cp.spawn(cmd, args, Object.assign({stdio: 'pipe'}, opt || {}))
    p.stdout = p.stdout.pipe(bl())
    p.stderr = p.stderr.pipe(bl())

    if (pFnc) {
      pFnc(p)
    }

    p.once('exit', (code, sig) => {
      if (code || sig) {
        console.log(['[cmd]', [cmd].concat(args).map(JSON.stringify).join(' '), '[stdout]', String(p.stdout), '[stderr]', String(p.stderr)].join('\n')) // eslint-disable-line no-console
        reject(new Error('Process unexpectedly quit with ' + (code || sig)))
      } else {
        resolve(p)
      }
    })
  })
}

async function exec (cmd, ...a) {
  return spawn(cmd.shift(), cmd, ...a)
}

const MAINDIR = path.dirname(path.dirname(__dirname))
const SRCDIR = os.homedir()
const REMOTEDIR = path.dirname(MAINDIR)
const read = (...a) => String(fs.readFileSync(path.join(...a)))
const write = (content, ...a) => fs.writeFileSync(path.join(...a), content)
const exists = (...a) => fs.existsSync(path.join(...a))

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
  write,
  exists,
  spawn,
  exec,
  match
}
