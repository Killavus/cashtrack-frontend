Reflux              = require('reflux')
Immutable           = require('immutable')

AuthenticationStore = require('./authentication_store').Store
NotificationStore   = require('./notification_store').Store

Backend             = require('../adapters/backend')
BudgetActions       = Reflux.createActions(["Open", "Close"])

{Notify}            = require('./notification_store').Actions

BudgetStore = Reflux.createStore
  init: ->
    @budgets = new Immutable.List([])
    @ready   = false
    @backend = Backend

    @listenTo(AuthenticationStore, "authenticationChanged")
    @listenTo(NotificationStore, "notified")
    @listenTo(BudgetActions.Open,  "openBudget")

  getInitialState: ->
    @data()

  data: ->
    new Immutable.Map(ready: @ready, budgets: @budgets)

  openBudget: (name) ->
    @backend.post('budget', budget: { name: name }).then (budgetJSON) =>
      @budgets = @budgets.concat(Immutable.fromJS([{ id: budgetJSON.budget_id, name: name }]))
      @trigger(@data())
      Notify(name: 'budgetCreated', arguments: [budgetJSON.budget_id, name])
    .fail =>
      Notify(name: 'budgetCreationFailed')

  authenticationChanged: (authentication) ->
    if authentication
      @backend.authenticate(authentication)
      unless @ready
        @fetchBudgetsFromBackend()

  fetchBudgetsFromBackend: ->
    @backend.get('budgetoverview').then (budgetsJSON) =>
      @budgets = Immutable.fromJS(budgetsJSON.budgets)
      @ready = true
      @trigger(@data())
      Notify(name: 'budgetsFetched')
    .fail =>
      Notify(name: 'budgetsFetchFailed')

  notified: (notification) ->
    switch notification.name
      when 'authenticated'
        @ready = false
        @trigger(@data())
        @fetchBudgetsFromBackend()
      when 'signedOut'
        @ready = false
        @trigger(@data())
        @fetchBudgetsFromBackend()

module.exports =
  Store: BudgetStore
  Actions: BudgetActions
