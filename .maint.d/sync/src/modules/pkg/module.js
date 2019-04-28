'use strict'

const cp = require('child_process')

function PKG (name, ver, format) {
  let formatted = format.replace('NAME', name).replace('VER', ver)
  return {
    name,
    ver,
    formatted,
    toString: () => formatted,
    compare: (other) => other.name === name && other.ver === ver
  }
}

const bl = require('bl')

function spawn (cmd, args) {
  return new Promise((resolve, reject) => {
    const p = cp.spawn(cmd, args, {stdio: 'pipe'})
    p.stdout = p.stdout.pipe(bl())
    p.stderr = p.stderr.pipe(bl())

    p.once('exit', (code, sig) => {
      if (code || sig) {
        reject(new Error('Process unexpectedly quit with ' + (code || sig)))
      } else {
        resolve(p)
      }
    })
  })
}

module.exports = function PKGModule (config) {
  async function genericInstall (cmd, multi, pkg) {
    let batches = multi ? [pkg] : pkg.map(p => [p])
    let splitIndex = cmd.indexOf(cmd)
    let pre = cmd.slice(0, splitIndex - 1)
    let post = cmd.slice(splitIndex + 1)
    cmd = pre.shift()
    await Promise.all(batches.map(batch => spawn(cmd, pre.concat(batch).concat(post))))
  }

  async function exec (cmd) {
    return spawn(cmd.shift(), cmd)
  }

  let parseFormatted = config.process.regex.match(/\/(.+)\/(.+)/)
  let parseRegex = new RegExp(parseFormatted[1], parseFormatted[2])
  let regexGroups = config.process['regex-groups']

  return {
    list: async () => {
      let list = await exec(config.commands.list)
      return String(list.stdout)
        .split('\n')
        .filter(Boolean)
        .map(str => str.match(parseRegex))
        .filter(Boolean) // TODO: list invalid entries
        .map(res => PKG(res[regexGroups.name], res[regexGroups.version], config.process['pkg-format']))
    },
    install: (pkgs) => genericInstall(config.commands.install, config.commands['install.multi']),
    remove: (pkgs) => genericInstall(config.commands.remove, config.commands['remove.multi']),
    update: (pkgs) => genericInstall(config.commands['update.useinstall'] ? config.commands.install : config.commands.update, config.commands['update.multi'])
  }
}
