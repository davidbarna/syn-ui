describe 'syn.ui.dom.builder.Nav', ->

  NavBuilder = require( 'src/lib/dom/builder/nav' )
  $ = require( 'jqlite' )
  sandbox = instance = config = element = null

  BUTTON = 'syn-nav_button'

  beforeAll ->
    sandbox = sinon.sandbox.create()
    config =
      active: 'button3'
      nav:
        button1: 'Button 1'
        button2:
          label: 'Button 2'
          classes: [ 'custom-class-1' ]
          on:
            click: sandbox.stub()
            keypress: sandbox.stub()
        button3:
          label: 'Button 3'
          nav:
            subbutton: 'Sub button'
    sandbox.spy( NavBuilder.prototype, 'emit' )
    instance = new NavBuilder()

  afterAll ->
    instance.destroy()
    sandbox.restore()

  describe '#build', ->

    beforeAll ->
      instance.build( config )

    it 'should create all buttons', ->
      elem = instance.element
      elem.getElementsByClassName( BUTTON ).length
        .should.equal 4
      elem.querySelectorAll( '.syn-nav_button.-level-0' ).length
        .should.equal 3
      elem.querySelectorAll( '.syn-nav_button.-level-1' ).length
        .should.equal 1

    it 'should activate "active" element', ->
      NavBuilder::emit.should.have.been.calledOnce
      NavBuilder::emit.args[0][0].should.equal instance.CLICK
      NavBuilder::emit.args[0][1].id.should.equal config.active

  describe '#buildElements', ->

    it 'should add element to configs', ->
      instance.configs.button1.should.exist
      instance.configs.subbutton.should.exist

    it 'should add DOM element to config', ->
      instance.configs.button1.element.innerHTML.should.exist

    it 'should element to DOM', ->
      html = instance.configs.button1.element.innerHTML
      instance.element.innerHTML.should.contain html

    it 'should build children elements', ->
      html = instance.configs.subbutton.element.innerHTML
      instance.element.innerHTML.should.contain html

  describe '#getElementConfig', ->
    result = null

    beforeAll ->
      result = instance.getElementConfig( 'button2', config.nav.button2, 0 )

    it 'should define id if unset', ->
      result.id.should.equal 'button2'

    it 'should add default classes', ->
      result.classes.indexOf( 'custom-class-1' ).should.not.equal -1
      result.classes.indexOf( BUTTON ).should.not.equal -1
      result.classes.indexOf( '-level-0' ).should.not.equal -1

    it 'should add default click hanlder', ->
      result.on.click.length.should.equal 2
      result.on.click[1]()
      instance.emit.should.have.been.called

    it 'should add populate property to avoid duplicated data', ->
      result.populated.should.equal true

  describe '#createElement', ->

    beforeAll ->
      element = instance.configs.button2.element

    it 'should add right class to each element', ->
      element.className.should.contain BUTTON
      element.className.should.contain '-level-0'
      element.className.should.contain 'custom-class-1'

    it 'should add right label to each element', ->
      element.innerHTML.should.contain 'syn-nav_label'
      element.innerHTML.should.contain 'Button 2'

    it 'should assign given events', ->
      $( element ).trigger( 'click' ).trigger( 'keypress' )
      config.nav.button2.on.click[0].should.have.been.called
      config.nav.button2.on.keypress[0].should.have.been.called

  describe '#buildChildrenElements', ->

    it 'should add sub class', ->
      instance.element.getElementsByClassName( 'syn-nav_sub' ).length
        .should.equal 1

    describe 'when FLAT mode', ->

      beforeAll ->
        instance
          .destroy()
          .setStructure( instance.FLAT )
          .build( config )

      it 'should not nest elements', ->
        $( instance.element ).find( 'li' ).find( 'ul' ).length
          .should.equal 0

    describe 'when LAYERED mode', ->

      beforeAll ->
        instance
          .destroy()
          .setStructure( instance.LAYERED )
          .build( config )

      it 'should nest elements', ->
        $( instance.element ).find( 'li' ).find( 'ul' ).length
          .should.equal 1

  describe '#getItem', ->

    it 'should return item\'s config', ->
      instance.getItem( 'button2' )
        .label.should.equal 'Button 2'


  describe '#destroy', ->

    button2Element = null
    beforeAll ->
      element = instance.element
      button2Element = instance.getItem( 'button2' ).element
      sandbox.spy( instance, 'destroyElement' )
      instance.destroy()

    it 'should remnove and destroy all elements', ->
      element.innerHTML.should.equal ''
      instance.destroyElement.callCount.should.equal 4
      instance.configs.should.deep.equal {}

    it 'should remove all listeners', ->
      config.nav.button2.populated.should.equal false
      config.nav.button2.on.click[0].reset()
      config.nav.button2.on.keypress[0].reset()
      $( button2Element ).trigger( 'click' ).trigger( 'keypress' )
      config.nav.button2.on.click[0].should.not.have.been.called
      config.nav.button2.on.keypress[0].should.not.have.been.called
