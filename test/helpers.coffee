global.fs = require "fs"
global.path = require "path"
global.util = require "util"
global.glob = require "glob"
global.wrench = require( "wrench" )
global.sinon = require "sinon"
global.shld = require "should"

global.__testsRootDir = __dirname
global.__tmpDir = path.join __dirname, ".tmp"
global.rc = require "../index.js"

do ->
  global.__homepaths = {}

  for own home in [ "home1", "home2", "home3", "home4", "ini", "json", "plist", "yaml" ]
    global.__homepaths[ home ] = fs.realpathSync path.join __dirname, "fixtures", "homes", home