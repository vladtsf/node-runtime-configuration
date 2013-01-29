# YAML configs coder/decoder
class YAMLAdapter

  yaml = require "yaml"

  # Detect passed data format
  #
  # @param [String] data
  # @return [Object] is it yaml?
  #
  @detect: ->
    on

  # Parse passed data.
  #
  # @param [String] data data to parse
  # @return [Object] parsed object
  #
  @parse: ( data ) ->
    yaml.eval data

  # Stringify passed object.
  #
  # @param [Object] data object to stringify
  # @return [String] result string
  #
  @stringify: ( data ) ->
    throw new Error "Unfortunately, YAML serialization not supported yet"

module.exports = YAMLAdapter