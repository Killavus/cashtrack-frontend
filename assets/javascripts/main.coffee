$ = require 'jquery'
window.jQuery = $

CashTrack = require('./app/cashtrack')
Backend = require('./app/adapters/backend')

$(document).ready ->
  console.log $("[role=flash-container]")
  Backend.setApiRoot($("body").data("apiRoot"))
  window.App = new CashTrack()
  window.App.start()
