# Configuration class
class ConfigParser

  fs = require "fs"
  # url = require "url"
  # util = require "util"
  # glob = require "glob"
  # path = require "path"
  # async = require "async"
  # optimist = require "optimist"

  # Construct a ConfigParser.
  #
  # @param [String] @path path to file
  #
  constructor: ( @path ) ->
    @format = null

  # Pick config format.
  #
  # @param [Function] callback
  # @return [ConfigParser]
  #
  pick: ( callback = -> ) ->
    fs.readFile @path, "utf8", ( err, @rawData ) =>
      return callback.call( @, err ) if err

      for own format in ConfigParser.formats
        try
          @parse format
          @format = format
          break
        catch e
          continue

      return callback.call( @, new Error( "Format not supported" ) ) unless @format

      callback.call @

    @

  # Parse config.
  #
  # @param [String] format config format
  # @return [ConfigParser]
  #
  parse: ( format ) ->
    adapter = require "./adapters/#{ format }"

    if @rawData is ""
      @_parsed = {}
    else if adapter.detect @rawData
      @_parsed = adapter.parse @rawData
    else
      throw new Error()

    @

  # Parse config.
  #
  # @return [String] stringified value
  #
  stringify: ( format ) ->
    require( "./adapters/#{ format ? @format }" ).stringify @_parsed

  # Supported formats.
  @formats: [ "json", "plist", "ini", "yaml" ]

module.exports = ConfigParser