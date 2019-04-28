'use strict'

const cp = require('child_process')
const path = require('path')
const {SRCDIR, read, write, exists, match} = require('../utils')

const DCONF = module.exports = {
  export (path) {
    let out = read(SRCDIR, path)
    return out.replace(new RegExp(SRCDIR, 'g'), '$HOME')
  },
  import (path, out) {
    out = out.replace(/\$HOME/g, SRCDIR)
    return write(out + '\n', SRCDIR, path)
  },
  exists (path) {
    return exists(SRCDIR, path)
  },
  merge (local, remote) {
    for (const group in remote) {
      if (!local[group]) { local[group] = {} } // create local group if it does not exist already
      for (const key in remote[group]) {
        local[group][key] = remote[group][key] // override keys with values from remote
      }
    }

    return local
  },
  parse (dconf) {
    let settings = {}
    let cur

    dconf.split('\n').filter(Boolean).forEach(line => {
      if (line.startsWith('[')) {
        let name = line.replace('[', '').replace(']', '')
        settings[name] = cur = {}
      } else if (~line.indexOf('=')) { // TODO: use re /^\t(.+) = (.+)$/
        let [name, ...content] = line.split(' = ')
        cur[name.replace(/^\t/, '')] = content.join(' = ')
      }
    })

    return settings
  },
  stringify (conf) {
    let out = ''
    for (const group in conf) {
      out += `[${group}]\n`
      for (const key in conf[group]) {
        out += `\t${key} = ${conf[group][key]}\n`
      }
    }

    return out
  },
  applyIgnore (orig, config, inv) {
    const stripped = JSON.parse(JSON.stringify(orig)) // TODO: perf

    for (const group in stripped) {
      for (const key in stripped[group]) {
        if (match(`${group}@${key}`, config, inv)) {
          delete stripped[group][key]
        }
      }

      if (!Object.keys(stripped[group]).length) {
        delete stripped[group]
      }
    }

    return stripped
  }
}
