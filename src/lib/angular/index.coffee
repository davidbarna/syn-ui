angular = require( 'angular-bsfy' )

module.exports =
  getModule: ->
    angular
      .module( 'syn.ui', [] )
      .directive( 'synAppHeader', require( '../../components/app-header/ng-directive' ) )
      .directive( 'synNavStack', require( '../../components/nav-stack/ng-directive' ) )
