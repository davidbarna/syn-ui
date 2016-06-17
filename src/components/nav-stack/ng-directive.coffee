navStackDirective =
  scope:
    options: '&'
    channel: '@'
  transclude: true
  controller: [ '$scope', '$element', '$transclude', ( scope, elem, trans ) ->

    # Convert scope attr to plain
    elem.attr( 'channel', scope.channel )

    # Gets optiosn whether from inline json or scope variable
    getOptions = ( elem ) ->
      options = {}
      options = scope.options() || options
      try options = JSON.parse( elem.html() )

      return options

    NavStack = require( './ctrl' )
    ctrl = new NavStack( elem )
    require( 'syn-core' ).angularify( scope, ctrl )
    trans( ( clone ) ->
      ctrl.init( getOptions( clone ) )
    )
  ]

module.exports = -> navStackDirective
