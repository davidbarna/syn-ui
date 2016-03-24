require( 'jade/runtime' )

window.syn ?= {}
window.syn.ui ?=
  angular: require( './lib/angular' )

module.exports = window.syn.ui
