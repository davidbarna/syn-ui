angular = require( 'angular-bsfy' )
module.exports =
  getModule: ->
    angular
      .module( 'syn.ui', [] )
      .run ->
        document.body.innerHTML = 'syn-ui angular module initialized'
