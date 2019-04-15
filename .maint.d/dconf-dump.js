'use strict'

const cp = require('child_process')
const dconf = String(cp.execSync('dconf dump /'))
const fs = require('fs')
const path = require('path')
const minimatch = require('minimatch')

let settings = {}
let cur

let strip = String(fs.readFileSync(path.join(__dirname, 'dconf-ignore'))).split('\n').filter(Boolean).map(line => {
  let neg = line.startsWith('!')
  return {line: neg ? line.substr(1) : line, neg}
})

function dconfToString(conf) {
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

dconf.split('\n').filter(Boolean).forEach(line => {
  if (line.startsWith('[')) {
    let name = line.replace('[', '').replace(']', '')
    settings[name] = cur = {}
  } else if (~line.indexOf('=')) {
    let [name, ...content] = line.split('=')
    cur[name] = content.join('=')
  }
})

const stripped = JSON.parse(JSON.stringify(settings))

for (const group in stripped) {
  for (const key in stripped[group]) {
    let id = `${group}@${key}`
    let del = Boolean(strip.filter(m => !m.neg && minimatch(id, m.line)).length)
    let nodel = Boolean(strip.filter(m => m.neg && minimatch(id, m.line)).length)
    if (del && !nodel) {
      console.log('DEL', group, key)
      delete stripped[group][key]
    }
  }
  
  if (!Object.keys(stripped[group]).length) {
    delete stripped[group]
  }
}

stripped['org/gnome/desktop/screensaver']['picture-uri'] = 'file://$MAIN/lock.png'
stripped['org/gnome/desktop/background']['picture-uri'] = 'file://$MAIN/wall.jpg'

fs.writeFileSync(path.join(__dirname, '..', '.mods.d', '7-desktop-configuration/dconf.conf'), dconfToString(stripped))
