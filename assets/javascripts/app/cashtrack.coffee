TopMenu = require('./menu/app')
Router = require('./application_router')

class CashTrack
  constructor: ->
    @topMenu = new TopMenu()
    @router  = new Router()

  start: ->
    topMenuNode = $("#topMenu")[0]
    contentNode = $("#contents")[0]

    @topMenu.start(topMenuNode)
    @router.start(contentNode)

module.exports = CashTrack