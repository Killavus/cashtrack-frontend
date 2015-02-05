$ = require 'jquery'
window.jQuery = $

CashTrack = require('./app/cashtrack')

$ ->
  window.App = new CashTrack()
  window.App.start()
