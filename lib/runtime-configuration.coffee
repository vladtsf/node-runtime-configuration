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

  # Lookup chain of configs.
  #
  # @return [Array] looked up paths
  #
  lookup: ->
    g1 = glob.sync "#{ process.env.HOME }/.#{ @appName }{rc,/config}"
    g2 = glob.sync "#{ process.env.HOME }/.config/{#{ @appName },#{ @appName }/config}"
    g3 = glob.sync "/etc/#{ @appName }{rc,/config}"

    [ g1..., g2..., g3... ].reverse()

  # $HOME/.${APPNAME}rc
  # $HOME/.${APPNAME}/config
  # $HOME/.config/${APPNAME}
  # $HOME/.config/${APPNAME}/config
  # /etc/${APPNAME}rc
  # /etc/${APPNAME}/config

  load: ->

  save: ->

  env: ->

  cli: ->

module.exports = RuntimeConfiguration