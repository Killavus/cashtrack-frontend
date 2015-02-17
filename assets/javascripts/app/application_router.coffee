_ = require('underscore')
$ = require('jquery')
{history, Router} = require('backbone')
NewBudgetApp = require('./new_budget/app')

class ApplicationRouter
  constructor: ->
  node: -> $("#contents")[0]

  buildRoutes: (router) ->
    router.route('budget/:id', (id) => console.log(id))
    router.route('new_budget', =>
      app = new NewBudgetApp()
      app.start(@node())
    )

  start: (@contentNode) ->
    router = new Router()
    @buildRoutes(router)


module.exports = ApplicationRouter