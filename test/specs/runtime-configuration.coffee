describe "RuntimeConfiguration", ->
    describe "@constructor()", ->
      it "should create new instance of rc.RuntimeConfiguration", ->

    describe "@lookup()", ->
      it "should lookup configs chain", ->

    describe "@load()", ->
      it "should invoke Adapter.pick()", ->
      it "should invoke @env()", ->
      it "should invoke @cli()", ->

    describe "@save()", ->
      it "should write ~/.apprc file", ->

    describe "@env()", ->
      it "should override config with env vars prefixed _APP", ->
      it "should support nesting (separated by __)", ->

    describe "@cli()", ->
      it "should override config with cli args", ->
      it "should support nesting (dot separated)", ->