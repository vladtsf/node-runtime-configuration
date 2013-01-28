describe "Runtime Configuration", ->

  before ->
    @originalEnv = process.env

  after ->

  beforeEach ->

  afterEach ->
    process.env = @originalEnv

  require "./specs/rc"
