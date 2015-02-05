_ = require('underscore')
{history, Router} = require('backbone')

class ApplicationRouter
  constructor: ->
    @buildRoutes()

  buildRoutes: ->

  start: (@contentNode) ->
    history.start(pushState: true)

module.exports = ApplicationRouter