describe "RuntimeConfiguration", ->
    describe "@constructor()", ->
      it "should create new instance of rc.RuntimeConfiguration", ->
        ( new rc.RuntimeConfiguration( "app" ) ).should.be.instanceOf rc.RuntimeConfiguration

      it "should raise if application name not specified", ->
        ( -> new rc.RuntimeConfiguration() ).should.throw "Application name not specified"

    describe "@lookup()", ->
      it "should lookup config in $HOME/.${APPNAME}rc", ->
        process.env.HOME = __homepaths.home1
        new rc.RuntimeConfiguration( "app" ).lookup().should.include path.join __homepaths.home1, ".apprc"

      it "should lookup config in $HOME/.${APPNAME}/config", ->
        process.env.HOME = __homepaths.home2
        new rc.RuntimeConfiguration( "app" ).lookup().should.include path.join __homepaths.home2, ".app", "config"

      it "should lookup config in $HOME/.config/${APPNAME}", ->
        process.env.HOME = __homepaths.home3
        new rc.RuntimeConfiguration( "app" ).lookup().should.include path.join __homepaths.home3, ".config", "app"

      it "should lookup config in $HOME/.config/${APPNAME}/config", ->
        process.env.HOME = __homepaths.home4
        new rc.RuntimeConfiguration( "app" ).lookup().should.include path.join __homepaths.home4, ".config", "app", "config"

      it "should lookup config in /etc/${APPNAME}rc", ->
        # Don't know how to test it properly

      it "should lookup config in /etc/${APPNAME}/config", ->
        # Don't know how to test it properly

    describe "@load()", ->
      beforeEach ( done ) ->
        @config = new rc.RuntimeConfiguration( "app" )
        @lookup = sinon.spy @config, "lookup"
        @pick = sinon.spy rc.ConfigParser.prototype, "pick"
        @env = sinon.spy @config, "env"
        @cli = sinon.spy @config, "cli"

        @config.load done

      afterEach ->
        @pick.restore()

        delete @config
        delete @lookup
        delete @pick
        delete @env
        delete @cli

      it "should invoke @lookup()", ->
        @lookup.calledOnce.should.be.true

      it "should invoke rc.ConfigParser.pick()", ->
        @pick.called.should.be.true

      it "should invoke @env()", ->
        @env.calledOnce.should.be.true

      it "should invoke @cli()", ->
        @cli.calledOnce.should.be.true


    describe "@env()", ->
      beforeEach ( done ) ->
        process.env.APP_TEST_VAR = "foo"
        process.env.APP_TEST__VAR = "bar"
        @config = new rc.RuntimeConfiguration( "app" ).load done

      afterEach ->
        delete @config

      it "should override config with env vars prefixed APP_", ->
        @config.config.should.have.property "testVar", "foo"

      it "should support nesting (separated by __)", ->
        @config.config.test.should
          .be.a( "object" )
          .and.have.property( "var", "bar" )

    describe "@cli()", ->

      beforeEach ( done ) ->
        @oldArgv = process.argv
        process.argv = [ []..., @oldArgv... ]
        process.argv.push "--foo", "test1", "--bar.baz", "test2"

        @config = new rc.RuntimeConfiguration( "app" ).load done

      afterEach ->
        process.argv = @oldArgv

        delete @oldArgv
        delete @config

      it "should override config with cli args", ->
        @config.config.should.have.property "foo", "test1"

      it "should support nesting (dot separated)", ->
        @config.config.bar.should
          .be.a( "object" )
          .and.have.property( "baz", "test2" )

    describe "@set()", ->
      beforeEach ( done ) ->
        process.env.HOME = __tmpDir
        @config = new rc.RuntimeConfiguration( "app" )
        @config.load done

      afterEach ->
        delete @config

      it "should set only one key", ->
        @config.set "foo", "bar"
        @config.config.should.have.property "foo", "bar"

      it "should set many keys by object", ->
        @config.set bar: "baz", baz: "foo"
        @config.config.should.include bar: "baz", baz: "foo"

    describe "@get()", ->
      beforeEach ( done ) ->
        process.env.HOME = __tmpDir
        @config = new rc.RuntimeConfiguration( "app" )
        @config.load ( err ) ->
          @set "foo", "bar"
          done err

      afterEach ->
        delete @config

      it "should get value by key", ->
        @config.get( "foo" ).should.equal "bar"

      it "should return entire object if key not specified", ->
        @config.get().should.be.a "object"

    describe "@save()", ->
      beforeEach ( done ) ->
        process.env.HOME = __tmpDir

        @write = sinon.spy fs, "writeFile"
        @config = new rc.RuntimeConfiguration( "app" )

        @config.load ( err, config ) ->
          @config.foo = "bar"
          @save done

      afterEach ->
        @write.restore()

        delete @config
        delete @write

      it "should write ~/.apprc file", ->
        args = @write.getCall( 0 ).args

        args[ 0 ].should.equal path.join __tmpDir, ".apprc"
        JSON.parse( args[ 1 ] ).should.have.property "foo", "bar"
