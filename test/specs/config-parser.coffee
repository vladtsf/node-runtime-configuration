describe "ConfigParser", ->
    before ->
      @suitable = new rc.ConfigParser path.join __homepaths.home1, ".apprc"
      @json = new rc.ConfigParser path.join __homepaths.json, ".apprc"
      @yaml = new rc.ConfigParser path.join __homepaths.yaml, ".apprc"
      @ini = new rc.ConfigParser path.join __homepaths.ini, ".apprc"
      @plist = new rc.ConfigParser path.join __homepaths.plist, ".apprc"

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
        @json._parsed.should.be.a "object"

      it "should raise an error when can't parse", ->
        ( => @plist.parse( "json" ) ).should.throw()

    describe "@stringify()", ->
      it "should serialize object to appropriate format", ->
        @json.stringify().should.be.a "string"
