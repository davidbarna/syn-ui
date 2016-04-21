DomBuilderNav = require( '../../lib/dom/builder/nav' )
core = require( 'syn-core' )

###
 * # NavStackCtrl
 *
 * Creates a navigation stack in DOM and
 * handles its events
###
class NavStackCtrl

  CLASS: 'syn-nav-stacked'
  COMPACT_CLASS: 'syn-nav-stacked--compact'
  ACTIVE_CLASS: '-active'

  ###
   * Sets active element and publishes a click events
   * through defined channel
   * @param  {Object} item Config object
   * @param  {MouseEvent} event
   * @return {undefined}
  ###
  _clickHandler: ( item, event ) =>
    event?.stopPropagation()
    @setActive( item )
    @pub?.click.publish( item )
    return

  ###
   * @constructor
   * @param  {jqLite} @element DOM Element
  ###
  constructor: ( @element ) ->
    elem = @element[0]
    @isCompact = elem.hasAttribute( 'compact' )
    @channel = elem.getAttribute( 'channel' )
    @active = null

    @nav = new DomBuilderNav()
    @pub = core.pubsub.channel.factory.create( @channel, [ 'click' ] ) if !!@channel


  ###
   * Builds nav and appends it to DOM
   * @param  {Object} config See DomBuilderNav.build
   * @returns {NavStackCtrl} `this`
  ###
  init: ( config ) ->
    @nav
      .setCssPrefix( @CLASS )
      .on( @nav.CLICK, @_clickHandler )
      .build( config )
    @nav.element.classList.add( @COMPACT_CLASS ) if @isCompact
    @element.addClass( @CLASS )
    @element.append( @nav.element )
    return this

  ###
   * Changes the state of the active element.
   * @param {Object} item Config object return by DomBuilderNav on click event
   * @param {DOM Element} item.element Element to activate
   * @returns {NavStackCtrl} `this`
  ###
  setActive: ( item ) ->
    @active.classList.remove( @ACTIVE_CLASS ) if !!@active
    @active = item.element
    @active.classList.add( @ACTIVE_CLASS )
    return this


  ###
   * @returns {NavStackCtrl} `this`
  ###
  destroy: ->
    @nav.removeListener( @nav.CLICK, @_clickHandler  )
    @nav.destroy()
    @pub?.destroy()
    @element.remove()
    @element = @nav = @isCompact = null
    return this



module.exports = NavStackCtrl
