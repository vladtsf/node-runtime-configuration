# INI configs coder/decoder
class INIAdapter

  ini = require "ini"

  @detect: ( data ) ->
    /^(\s+)?\[|[\w\d]+\s+?\=/.test data

  # Parse passed data.
  #
  # @param [String] data data to parse
  # @return [Object] parsed object
  #
  @parse: ( data ) ->
    ini.parse data

  # Stringify passed object.
  #
  # @param [Object] data object to stringify
  # @return [String] result string
  #
  @stringify: ( data ) ->
    ini.stringify data

module.exports = INIAdapter