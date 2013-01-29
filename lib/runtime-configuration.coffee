# Configuration class
class RuntimeConfiguration

  rc = require "./index"
  fs = require "fs"
  url = require "url"
  util = require "util"
  glob = require "glob"
  path = require "path"
  async = require "async"
  optimist = require "optimist"
  extend = require "node.extend"

  # Construct a new RuntimeConfiguration.
  #
  # @param [String] @appName application name
  # @param [Object] @defaults defaults object
  #
  constructor: ( @appName, @defaults = {} ) ->
    throw new Error( "Application name not specified" ) unless @appName?

    # config overrides chain
    @_chain = []

  # Lookup chain of configs.
  #
  # @return [Array] looked up paths
  #
  lookup: ->
    g1 = glob.sync "#{ process.env.HOME }/.#{ @appName }{rc,/config}"
    g2 = glob.sync "#{ process.env.HOME }/.config/{#{ @appName },#{ @appName }/config}"
    g3 = glob.sync "/etc/#{ @appName }{rc,/config}"

    [ g1..., g2..., g3... ].reverse()

  # Load configuration.
  #
  # @param [Function] callback
  # @return [RuntimeConfiguration] rc instance
  #
  load: ( callback = -> ) ->
    chain = @_chain = []

    iteration = ( item, done ) ->
      new rc.ConfigParser( item.file ).pick ->
        done null, chain.push @_parsed

    # load configs
    async.forEach ( { file, idx } for own file, idx in @lookup() ), iteration, ( err ) =>
      @cli()


    # for own path in @lookup()
    #   new rc.Adapter( path ).pick()

    callback()

  save: ->

  env: ->

  # Load cli args overrides
  #
  # @return [RuntimeConfiguration] rc instance
  #
  cli: ->
    cliArgs = extend {}, optimist.argv
    delete cliArgs._
    delete cliArgs[ "$0" ]

    @_chain.push cliArgs

    @


module.exports = RuntimeConfiguration