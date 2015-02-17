TopMenu             = require('./menu/app')
Router              = require('./application_router')
_                   = require('underscore')
Backbone            = require('backbone')

AuthenticationStore = require('./stores/authentication_store').Store

class CashTrack
  constructor: ->
    @topMenu = new TopMenu()
    @router  = new Router()

  start: ->
    topMenuNode = $("#topMenu")[0]
    contentNode = $("#contents")[0]

    @topMenu.start(topMenuNode)
    @router.start(contentNode)
    Backbone.history.start()
    AuthenticationStore.start()

module.exports = CashTrack