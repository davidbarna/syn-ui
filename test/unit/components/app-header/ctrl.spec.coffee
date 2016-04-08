describe 'syn.ui.<synAppHeader />.ctrl', ->

  Ctrl = require( 'src/components/app-header/ctrl' )
  $ = require( 'jqlite' )
  gSession = require( 'syn-auth' ).session.global

  beforeEach ->
    @sinon = sinon.sandbox.create()
    @element = $( document.createElement( 'DIV' ) )
    @element.html( "<div class=\"#{Ctrl::USER_CLASS}\" />" )
    @instance = new Ctrl(  @element )
    @instance.render = @sinon.stub()

  afterEach ->
    @instance.destroy()
    @element.remove()
    @sinon.restore()
    gSession.clear()

  describe 'constructor', ->

    beforeEach ->
      @sinon.stub Ctrl.prototype, 'toggleUser'
      new Ctrl(  @element )

    it 'should hide user card', ->
      Ctrl::toggleUser.should.have.been.calledOnce

  describe '#init', ->

    beforeEach ->
      @sinon.stub Ctrl.prototype, 'setUser'
      @sinon.stub gSession, 'get', -> user: -> 'fakeUser'
      @instance.init()

    it 'should set user of current session', ->
      Ctrl::setUser.should.have.been.calledWith 'fakeUser'

    it 'should listen to session.CHANGE to update user card', ->
      Ctrl::setUser.reset()
      gSession.emit gSession.CHANGE, user: -> 'fakeUser2'
      Ctrl::setUser.should.have.been.calledWith 'fakeUser2'

    it 'should listen to user click event', ->
      stub = @sinon.stub( gSession, 'clear' )
      @instance._userElement.trigger( 'click' )
      stub.should.have.been.calledOnce

  describe '#setUser', ->

    beforeEach ->
      @sinon.stub @instance, 'toggleUser'

    describe 'when user is set', ->

      beforeEach ->
        @user =
          avatar: -> 'fakeAvatar'
          name: -> 'fakeName'
          username: -> 'fakeUsername'
        @instance.setUser( @user )

      it 'should update the view with user\'s info', ->
        @instance.render.should.have.been.calledOnce
        @instance.render.args[0][0].user.img.should.equal 'fakeAvatar'
        @instance.render.args[0][0].user.title.should.equal 'fakeName'
        @instance.render.args[0][0].user.subtitle.should.equal 'fakeUsername'

      it 'should show user info', ->
        @instance.toggleUser.should.have.been.calledWith true

    describe 'when user is not set', ->

      beforeEach ->
        @instance.setUser( null )

      it 'should not update the view', ->
        @instance.render.should.not.have.been.called

      it 'should hide user info', ->
        @instance.toggleUser.should.have.been.calledWith false

  describe '#toggleUser', ->

    beforeEach ->
      @userElem = @element[0].getElementsByClassName( @instance.USER_CLASS )

    describe 'when show is true', ->

      beforeEach ->
        @instance.toggleUser( true )

      it 'should show user DOM Element', ->
        @userElem[0].style.display.should.equal ''

    describe 'when show is false', ->

      beforeEach ->
        @instance.toggleUser( false )

      it 'should hide user DOM Element', ->
        @userElem[0].style.display.should.equal 'none'

  describe '#destroy', ->

    beforeEach ->
      @sinon.stub( gSession, 'clear' )
      @instance.destroy()


    it 'should remove events', ->
      gSession.listenerCount( gSession.CHANGE ).should.equal 0

      @instance._userElement.trigger( 'click' )
      gSession.clear.should.not.have.been.calledOnce
