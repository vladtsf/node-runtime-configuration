# Configuration class
class RuntimeConfiguration

  fs = require "fs"
  url = require "url"
  util = require "util"
  glob = require "glob"
  path = require "path"
  async = require "async"
  optimist = require "optimist"

  # Construct a new package.
  #
  # @param [String] @appName application name
  # @param [Object] @defaults defaults object
  #
  constructor: ( @appName, @defaults = {} ) ->
    throw new Error( "Application name not specified" ) unless @appName?

  lookup: ->

  load: ->

  save: ->

  env: ->

  cli: ->

module.exports = RuntimeConfiguration