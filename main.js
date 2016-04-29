#!/usr/local/bin/node --harmony_destructuring
const util = require('util');
const PEG = require("./arithmetics.js");
var input = process.argv[2] || "(a = 5)+3*a";
console.log(`Processing <${input}>`);
var r = PEG.parse(input);
console.log(util.inspect(r, {showHidden: false, depth: null}));
