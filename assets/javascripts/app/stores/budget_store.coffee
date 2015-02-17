Reflux              = require('reflux')
Immutable           = require('immutable')

AuthenticationStore = require('./authentication_store').Store

Backend             = require('../adapters/backend')
BudgetActions       = Reflux.createActions(["Open", "Close"])

BudgetStore = Reflux.createStore
  init: ->
    @budgets = new Immutable.List([])
    @ready   = false
    @backend = Backend

    @listenTo(AuthenticationStore, "authenticationChanged")
    @listenTo(BudgetActions.Open, "openBudget")
    @listenTo(BudgetActions.Close, "closeBudget")

  getInitialState: ->
    @data()

  data: ->
    new Immutable.Map(ready: @ready, budgets: @budgets)

  authenticationChanged: (authentication) ->
    if authentication
      @backend.authenticate(authentication)
      unless @ready
        @backend.get('budgetoverview').then (budgetsJSON) =>
          @budgets = Immutable.fromJS(budgetsJSON.budgets)
          @ready = true
          @trigger(@data())

module.exports =
  Store: BudgetStore
  Actions: BudgetActions
