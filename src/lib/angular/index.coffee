angular = require( 'angular-bsfy' )

module.exports =
  getModule: ->
    angular
      .module( 'syn.ui', [] )
      .directive( 'synAppHeader', require( '../../app-header/ng-directive' ) )
