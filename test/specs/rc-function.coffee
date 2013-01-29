describe "rc()", ->
  before ( done ) ->
    @callback = sinon.spy done
    rc "app", @callback

  after ->
    delete @callback

  it "should invoke callback with configuration object", ->
    @callback.getCall( 0 ).args[ 1 ].should.be.a "object"

  it "should create an instance of rc.RuntimeConfiguration", ->
    @callback.getCall( 0 ).thisValue.should.be.instanceOf rc.RuntimeConfiguration