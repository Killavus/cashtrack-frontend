$ = require 'jquery'
window.jQuery = $

CashTrack = require('./app/cashtrack')

$(document).ready ->
  window.App = new CashTrack()
  window.App.start()
