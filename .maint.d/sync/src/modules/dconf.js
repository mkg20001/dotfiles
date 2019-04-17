'use strict'

const cp = require('child_process')
const path = require('path')
const {match} = require('../utils')

const DCONF = module.exports = {
  export (path) {
    return String(cp.execSync('dconf dump ' + JSON.stringify(path))) // export dconf as string
  },
  import (path, str) {
    str.replace(/\$MAIN/g, path.join(path.dirname(path.dirname(path.dirname(path.dirname(__dirname)))), '.mods.d/7-desktop-configuration/pics/')) // path for the background pictures
    cp.spawnSync('dconf load ' + JSON.stringify(path), {stdin: Buffer.from(str)}) // then push that into dconf
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
  parse(dconf) {
    let settings = {}
    let cur

    dconf.split('\n').filter(Boolean).forEach(line => {
      if (line.startsWith('[')) {
        let name = line.replace('[', '').replace(']', '')
        settings[name] = cur = {}
      } else if (~line.indexOf('=')) {
        let [name, ...content] = line.split('=')
        cur[name] = content.join('=')
      }
    })

    // hack
    settings['org/gnome/desktop/screensaver']['picture-uri'] = "'file://$MAIN/lock.png'"
    settings['org/gnome/desktop/background']['picture-uri'] = "'file://$MAIN/wall.jpg'"

    return settings
  },
  stringify(conf) {
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
  applyIgnore(orig, config, inv) {
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
