describe "Runtime Configuration", ->

  before ->
    @originalEnv = util._extend {}, process.env
    @originalArgv = util._extend [], process.argv

  after ->

  beforeEach ->
    process.env[ if process.platform is "win32" then "USERPROFILE" else "HOME" ] = __homepaths.json
    try fs.mkdirSync __tmpDir

  afterEach ->
    process.env = @originalEnv
    process.argv = @originalArgv
    try wrench.rmdirSyncRecursive __tmpDir


  require "./specs/rc"
