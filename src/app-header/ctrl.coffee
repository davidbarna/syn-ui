gSession = require( 'syn-auth' ).session.global

###
 *
###
class AppHeaderCtrl

  USER_CLASS: 'syn-app-header_user'

  ###
   * @param  {Session} session
   * @return {undefined}
  ###
  _sessionChangeHandler: ( session ) =>
    @setUser( session?.user() )
    return

  ###
   * @constructor
   * @param  {DOM Element} @elem
  ###
  constructor: ( @elem ) ->
    @toggleUser( false )

  ###
   * Sets user's card and listen to session changes
   * @return {AppHeaderCtrl} this
  ###
  init: ->
    @setUser( gSession.get()?.user() )
    gSession.on( gSession.CHANGE, @_sessionChangeHandler )
    return this

  ###
   * Sets user data to the view and show its card
   * @param {Object} user
   * @param {function} user.avatar Returns user's avatar image
   * @param {function} user.name Returns user's full name
   * @param {function} user.username Returns user's username
  ###
  setUser: ( user ) ->
    @toggleUser( !!user )
    return if !user
    @render(
      user: { img: user.avatar(), title: user.name(), subtitle: user.username() }
    )

  ###
   * Shows/hides user's card element
   * @param  {Boolean} show
   * @return {undefined}
  ###
  toggleUser: ( show ) ->
    @_userElement ?= @elem[0].getElementsByClassName( @USER_CLASS )[0]
    @_userElement.style.display = if show then null else 'none'
    return

  ###*
   * Removes all events
   * @return {undefined}
  ###
  destroy: ->
    gSession.removeListener( gSession.CHANGE, @_sessionChangeHandler )
    return


module.exports = AppHeaderCtrl
