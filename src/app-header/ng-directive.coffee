appHeaderDirective =
  scope: true
  template: require( './tpl' )
  controller: [ '$scope', ( scope ) ->
    AppHeaderCtrl = require( './ctrl' )
    ctrl = new AppHeaderCtrl()
    require( 'dev-tools' ).angularify( scope, ctrl )
    ctrl.init()
    scope.$on( '$destroy', -> ctrl.destroy() )
  ]

module.exports = -> appHeaderDirective
