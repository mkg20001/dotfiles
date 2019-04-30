'use strict'

/* eslint-disable guard-for-in */

const P = require('path')
const {match, exec} = require('../utils')
const bl = require('bl')

module.exports = {
  async export (path) {
    return String((await exec(['dconf', 'dump', path])).stdout) // export dconf as string
  },
  async import (path, str) {
    str = str.replace(/\$MAIN/g, P.join(P.dirname(P.dirname(P.dirname(P.dirname(__dirname)))), '.mods.d/7-desktop-configuration/pics/')) // path for the background pictures
    await exec(['dconf', 'load', path], {}, (p) => {
      bl(Buffer.from(str)).pipe(p.stdin)
    }) // then push that into dconf
  },
  exists (path) { // if it doesn't, dconf dump will simply not give any output
    return true
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
      } else if (line.indexOf('=') !== -1) {
        let [name, ...content] = line.split('=')
        cur[name] = content.join('=')
      }
    })

    // hack
    if (settings['org/gnome/desktop/screensaver']) {
      settings['org/gnome/desktop/screensaver']['picture-uri'] = "'file://$MAIN/lock.png'"
    }
    if (settings['org/gnome/desktop/background']) {
      settings['org/gnome/desktop/background']['picture-uri'] = "'file://$MAIN/wall.jpg'"
    }

    return settings
  },
  stringify (conf) {
    let out = ''
    for (const group in conf) {
      out += `[${group}]\n`
      for (const key in conf[group]) {
        out += `${key}=${conf[group][key]}\n`
      }
      out += '\n'
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
