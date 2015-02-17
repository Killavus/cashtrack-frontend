_ = require('underscore')
$ = require('jquery')
{history, Router} = require('backbone')
OpenBudgetApp = require('./open_budget/app')

NotificationStore = require('./stores/notification_store').Store

class ApplicationRouter
  constructor: ->
  node: -> $("#contents")[0]

  buildRoutes: (router) ->
    router.route('budget/:id', (id) => console.log(id))
    router.route('open_budget', => OpenBudgetApp.start(@node()))

  navigate: (router, url) ->
    router.navigate(url, trigger: true)

  start: (@contentNode) ->
    router = new Router()
    @buildRoutes(router)

    NotificationStore.listen (notification) =>
      switch notification.name
        when 'budgetCreated'
          id = notification.arguments[0]
          @navigate(router, "budget/#{id}")


module.exports = ApplicationRouter