angular = require( 'angular' )
synTooltip = require( '../../components/tooltip/ng-directive' ).default
synTooltipTarget = require( '../../components/tooltip-target/ng-directive' ).default

module.exports =
  getModule: ->
    angular
      .module( 'syn.ui', [] )
      .directive( 'synAppHeader', require( '../../components/app-header/ng-directive' ) )
      .directive( 'synNavStack', require( '../../components/nav-stack/ng-directive' ) )
      .directive( 'synTooltip', -> return synTooltip )
      .directive( 'synTooltipTarget', -> return synTooltipTarget )
