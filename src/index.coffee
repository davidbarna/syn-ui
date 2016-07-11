require( 'jade/runtime' )

Messsages = require( './lib/messages' ).default

window.syn ?= {}
window.syn.ui ?=
  angular: require( './lib/angular' )
  messages: new Messsages()

module.exports = window.syn.ui
