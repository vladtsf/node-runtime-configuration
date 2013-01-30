describe "ConfigParser", ->
    before ->
      @suitable = new rc.ConfigParser path.join __homepaths.home1, ".apprc"
      @json = new rc.ConfigParser path.join __homepaths.json, ".apprc"
      @yaml = new rc.ConfigParser path.join __homepaths.yaml, ".apprc"
      @ini = new rc.ConfigParser path.join __homepaths.ini, ".apprc"
      @plist = new rc.ConfigParser path.join __homepaths.plist, ".apprc"
      @writeable = new rc.ConfigParser path.join __tmpDir, ".apprc"

    after ->
      delete @suitable
      delete @json
      delete @yaml
      delete @ini
      delete @plist

    describe "@constructor()", ->
      it "should create new instance of rc.ConfigParser", ->
        @suitable.should.be.instanceOf rc.ConfigParser

    describe "@pick()", ->

      it "should pick suitable format", ( done ) ->
        @suitable.pick ( err ) ->
          @format.should.not.be.null
          done()

      it "should pick json properly", ( done ) ->
        @json.pick ( err ) ->
          @format.should.equal "json"
          done()

      it "should pick yaml properly", ( done ) ->
        @yaml.pick ( err ) ->
          @format.should.equal "yaml"
          done()

      it "should pick ini properly", ( done ) ->
        @ini.pick ( err ) ->
          @format.should.equal "ini"
          done()

      it "should pick plist properly", ( done ) ->
        @plist.pick ( err ) ->
          @format.should.equal "plist"
          done()

    describe "@parse()", ->

      it "should try to parse config", ->
        @json.parse( "json" )
        @json.parsed.should.be.a "object"

      it "should raise an error when can't parse", ->
        ( => @plist.parse( "json" ) ).should.throw()

    describe "@stringify()", ->
      beforeEach ->
        @write = sinon.spy fs, "writeFile"
        @writeable.parsed.foo = "bar"

        @stringify = ( format, done, callback ) =>
          @writeable.stringify format, ( err ) =>
            callback.apply @, @write.getCall( 0 ).args
            done err


      afterEach ->
        @write.restore()

        delete @write
        delete @stringify

      it "should write file", ( done ) ->
        @stringify "json", done, ( file ) =>
          file.should.equal path.join __tmpDir, ".apprc"

      it "should serialize json properly", ( done ) ->
        @stringify "json", done, ( file, serialized ) =>
          JSON.parse( serialized ).should.have.property "foo", "bar"

      it "should serialize ini properly", ( done ) ->
        @stringify "ini", done, ( file, serialized ) =>
          ini.parse( serialized ).should.have.property "foo", "bar"

      it "should serialize yaml properly", ( done ) ->
        @stringify "yaml", done, ( file, serialized ) =>
          yaml.parse( serialized ).should.have.property "foo", "bar"

      it "should serialize plist properly", ( done ) ->
        @stringify "plist", done, ( file, serialized ) =>
          plist.parseStringSync( serialized ).should.have.property "foo", "bar"
