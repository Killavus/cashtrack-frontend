_ = require('underscore')
{history, Router} = require('backbone')

class ApplicationRouter
  constructor: ->

  buildRoutes: (router) ->
    router.route('budget/:id', (id) => console.log(id))
    router.route('new_budget', => console.log 'new budget')


  start: (@contentNode) ->
    router = new Router()
    @buildRoutes(router)


module.exports = ApplicationRouter