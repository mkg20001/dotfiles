'use strict'

const exec = require('child_process').execSync
const split = Buffer.from('0D1B5B3964', 'hex')
let out = exec("htop << f\nq\nf").toString() // run htop for a sec
out = out.substr(80).split(String(split))[0].split(' PID USER ')[0]
console.log(out.substr(0, out.length - 3))
// console.log("\n\n\n\n\n\n") //add line breaks (because reset)
