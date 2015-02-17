TopMenu             = require('./menu/app')
Router              = require('./application_router')
_                   = require('underscore')
Backbone            = require('backbone')

AuthenticationStore = require('./stores/authentication_store').Store

class CashTrack
  constructor: ->
    @router  = new Router()

  start: ->
    topMenuNode = $("#topMenu")[0]
    contentNode = $("#contents")[0]

    TopMenu.start(topMenuNode)
    @router.start(contentNode)
    Backbone.history.start()
    AuthenticationStore.start()

module.exports = CashTrack