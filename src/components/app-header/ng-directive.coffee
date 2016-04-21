appHeaderDirective =
  scope: true
  transclude: true
  template: require( './tpl' )

  controller: [ '$scope', '$element', '$transclude', ( scope, elem, trans ) ->
    # Original content of the directive is appended
    trans( (clone, scope) -> elem.append( clone ) )

    AppHeaderCtrl = require( './ctrl' )
    ctrl = new AppHeaderCtrl( elem )
    require( 'syn-core' ).angularify( scope, ctrl )
    ctrl.init()
  ]

module.exports = -> appHeaderDirective
