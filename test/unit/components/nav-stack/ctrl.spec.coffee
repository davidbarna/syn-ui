describe 'syn.ui.<syn-nav-stack />.ctrl', ->

  Ctrl = require( 'src/components/nav-stack/ctrl' )
  Nav = require( 'src/lib/dom/builder/nav' )
  $ = require( 'jqlite' )
  sandbox = instance = element = config = null

  beforeAll ->
    config =
      nav:
        button1: 'Button 1'
        button2: 'Button 2'
    sandbox = sinon.sandbox.create()
    element = $( document.createElement( 'DIV' ) )
    element.attr( 'compact', '' )
    element.attr( 'channel', 'my-test-channel' )


    instance = new Ctrl(  element )
    instance.render = sandbox.stub()

  afterAll ->
    instance.destroy()
    element.remove()
    sandbox.restore()

  describe '#init', ->

    beforeAll ->
      sandbox.spy( Nav.prototype, 'setCssPrefix' )
      sandbox.spy( Nav.prototype, 'on' )
      sandbox.spy( Nav.prototype, 'build' )
      instance.init( config )

    it 'should config nav builder', ->
      Nav::setCssPrefix.should.have.been.calledWith instance.CLASS
      Nav::on.should.have.been.calledWith Nav::CLICK, instance._clickHandler

    it 'should add css class to root element', ->
      element.hasClass( instance.CLASS ).should.equal true

    it 'should add nav element to root element', ->
      element.html().should.contain config.nav.button1

    describe 'when "compact" attribute is set', ->

      it 'should add compact class', ->
        element.html().should.contain instance.COMPACT_CLASS

  describe '#setActive', ->

    it 'should add active class to given element', ->
      instance.setActive instance.nav.getItem( 'button1' )

      elems = element[0].getElementsByClassName( '-active' )
      elems.length.should.equal 1
      elems[0].innerHTML.should.contain 'Button 1'

    it 'should maintain a single element with active class', ->
      instance.setActive instance.nav.getItem( 'button2' )

      elems = element[0].getElementsByClassName( '-active' )
      elems.length.should.equal 1
      elems[0].innerHTML.should.contain 'Button 2'

  describe '#_clickHandler', ->

    evt = buttonConfig = null

    beforeAll ->
      buttonConfig = instance.nav.configs.button1
      evt = stopPropagation: sandbox.stub()

      sandbox.spy( instance, 'setActive' )
      sandbox.spy( instance.pub.click, 'publish' )

      instance._clickHandler( buttonConfig, evt )

    it 'should stop propagation', ->
      evt.stopPropagation.should.have.been.calledOnce

    it 'should change active button', ->
      instance.setActive.should.have.been.calledOnce
      instance.setActive.should.have.been.calledWith buttonConfig

    it 'should publish click event', ->
      instance.pub.click.publish.should.have.been.calledOnce
      instance.pub.click.publish.should.have.been.calledWith buttonConfig

  describe '#destroy', ->

    beforeAll ->
      sandbox.spy( instance.pub, 'destroy' )
      sandbox.spy( Nav.prototype, 'destroy' )
      instance.destroy()

    it 'should destroy nav instance', ->
      Nav::destroy.should.have.been.calledOnce

    it 'should destroy pub', ->
      instance.pub.destroy.should.have.been.calledOnce
