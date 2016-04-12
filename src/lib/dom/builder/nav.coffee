EventEmitter = require( 'events' )
$ = require( 'jqlite' )
_ = require( 'lodash' )

###
# DomBuilderNav
Creates a multi-level menu depending on a config object.

## Options

| Name | Type | Description |
|------|------|-------------|
| nav | {Object} | List of buttons to add |
| nav.foo | {Object}| Definition of a button |
| head.foo.label | {String}| Name of the button |
| head.foo.nav | {String}| List of children buttons |
| head.foo.id | {String}| Unique id (optional) (default: foo) |
| head.foo.classes | {Array}| List of css classes to add to DOM Element |
| head.foo.on | {Object}| List of event handlers|
| head.foo.on.foo | {Function}| Event handler |
| [ active ] | {string} | Default active button |

```coffeescript

{
  nav:
    televisions:
      label: 'Televisions'
      classes: [ 'tv-icon' ]
      on:
        click: ( item ) -> alert( item.label )
        keypress: ( item, event ) -> alert( event.keyCode )
      nav:
        smart: 'Smart TV'
        led: 'LED'
        plasma: 'Plasma'
    cameras:
      label: 'Cameras'
}
```
###
class DomBuilderNav extends EventEmitter

  DEFAULT_GROUP_TAG: 'UL'
  DEFAULT_ITEM_TAG: 'LI'
  DEFAULT_PREFIX: 'syn-nav'

  FLAT: 'flat-structure'
  LAYERED: 'layered-structure'
  CLICK: 'syn.nav.click'

  ###
   * Defines defaults
   * @constructor
  ###
  constructor: ->
    @configs = {}
    @setCssPrefix( @DEFAULT_PREFIX )
    @setTags( @DEFAULT_GROUP_TAG, @DEFAULT_ITEM_TAG )
    @setStructure( @LAYERED )

    return this

  ###
   * Defines css prefix to use for all classes
   * @param {string} @_cssPrefix Valid css class name
  ###
  setCssPrefix: ( @_cssPrefix ) -> return this

  ###
   * Defines HTML tags to use for nav elements
   * @param {string} @_groupTag Tag for groups (levels)
   * @param {string} @_itemTag  Tag for items
  ###
  setTags: ( @_groupTag, @_itemTag ) -> return this

  ###
   * Defines the type of structure wanted. There are 2 options:
   * * DomBuilderNav.LAYERED: child levels are nested inside parent level
   * * DomBuilderNav.FLAT: child levels created in the root element
   * @param {string} @_structure
  ###
  setStructure: ( @_structure ) -> return this

  ###
   * Builds all elements defined by config
   * @param  {Object} config
   * @param  {String} config.active Id of an element to activate
   * @param  {Object[]} config.nav List of buttons
   * @return {DomBuilderNav} `this`
  ###
  build: ( config ) ->
    config = _.clone( config )
    @element = document.createElement(  @_groupTag )
    @buildElements( config.nav, @element )

    if !!config.active
      # Trigger item activation if option is set
      @emit( @CLICK, @getItem( config.active ) )

    return this

  ###
   * Builds given elements into target element
   * @param  {Object} elements List of buttons. See @createElement
   * @param  {DOM Element} target Parent DOM element
   * @param  {number} level = 0 Level of the elements
   * @return {DomBuilderNav} `this`
  ###
  buildElements: ( elements, target, level = 0 ) ->
    for key, conf of elements
      conf = @getElementConfig( key, conf, level )
      element = @createElement( conf )
      conf.element = element
      @configs[conf.id] = conf

      target.appendChild( element )
      @buildChildrenElements( conf, element, target ) if !!conf.nav

    return this

  ###
   * Creates a button element according to config
   * @param  {Object} conf [description]
   * @param  {string} conf.label Name to show as caption
   * @param  {string} conf.id Unique id
   * @param  {Array}  conf.classes Classes to add to element
   * @param  {Object} conf.on List of event handlers
   * @param  {Function[]} conf.on[eventName] Array of callbacks callback
   * @return {DOM Element}
  ###
  createElement: ( conf ) ->
    label = document.createElement( 'a' )
    label.className = @_cssPrefix + '_label -level-' + conf.level
    label.innerHTML = conf.label

    elem = document.createElement( conf.tagName )
    elem.className = conf.classes.join( ' ' )
    elem.appendChild( label )

    for evt, funcs of conf.on
      for func in conf.on[evt]
        elem.addEventListener( evt, func )

    return elem

  ###
   * Creates and inserts child element into parent or next to it
   * depending on choosen structure.
   * @param  {Object} conf Element conf
   * @param  {DOM Element} element
   * @param  {DOM Element} elementParent
   * @return {DomBuilderNav} `this`
  ###
  buildChildrenElements: ( conf, element, elementParent ) ->
    target = if @_structure is @LAYERED then element else elementParent

    subClass = @_cssPrefix + '_sub'
    container = document.createElement( @_groupTag )
    container.className = subClass + ' ' + '-level-' + conf.level
    target.appendChild( container )

    @buildElements( conf.nav, container, conf.level + 1 )
    return this

  ###
   * Defines final config of an element.
   * Defaults are filled.
   * @param  {string} key
   * @param  {Object} value Origin config
   * @param  {number} level
   * @return {Object}
  ###
  getElementConfig: ( key, value, level ) ->
    conf = if typeof value is 'string' then label: value else value
    return conf if conf.populated

    conf.level = level
    conf.id ?= key
    conf.tagName ?= @_itemTag

    # Css classes
    conf.classes ?= []
    conf.classes.push( @_cssPrefix + '_button' )
    conf.classes.push( '-level-' + conf.level )

    # Events handlers
    conf.on ?= {}
    for evt, func of conf.on
      conf.on[evt] = [conf.on[evt]] if typeof conf.on[evt] is 'function'
    conf.on.click ?= []
    conf.on.click.push( @getClickHandler( conf ) )

    conf.populated = true

    return conf

  ###
   * Returns a default click handler for a given element config
   * @param  {Object} conf See @createElement for detailed structure
   * @return {Function}
  ###
  getClickHandler: ( conf ) ->
    return ( event ) =>
      @emit( @CLICK, conf, event )

  ###
   * Returns item's conf according to given id
   * @param  {string} id Unique id or key
   * @return {Object} See @createElement for detailed structure
  ###
  getItem: ( id ) ->
    for key, conf of @configs
      return conf if conf.id is id

  ###
   * Destroys all event handlers
   * @return {DomBuilderNav} `this`
  ###
  destroy: ->
    @removeAllListeners()
    @destroyElement( conf ) for k, conf of @configs
    $( @element ).remove()
    @configs = {}
    @element = null
    return this

  ###
   * Removes all event handlers from element
   * @param  {Object} conf Button config
   * @return {DomBuilderNav} `this`
  ###
  destroyElement: ( conf ) ->
    elem = conf.element
    $( elem ).remove()
    delete conf.element
    for evt, funcs of conf.on
      for func in conf.on[evt]
        elem.removeEventListener( evt, func )

    return this



module.exports = DomBuilderNav
