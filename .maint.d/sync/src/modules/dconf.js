'use strict'

const cp = require('child_process')

const path = require('path')

const DCONF = module.exports = {
  export (path) {
    return String(cp.execSync('dconf dump ' + JSON.stringify(path)))
  },
  import (path, str) {
    str.replace(/\$MAIN/g, path.join(path.dirname(path.dirname(path.dirname(path.dirname(__dirname)))), '.mods.d/7-desktop-configuration/pics/'))
    cp.spawnSync('dconf load ' + JSON.stringify(path), {stdin: Buffer.from(str)})
  },
  parse(dconf) {
    let settings = {}

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

    return
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
  }
}
