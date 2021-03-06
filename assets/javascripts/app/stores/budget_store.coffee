Reflux              = require('reflux')
Immutable           = require('immutable')

AuthenticationStore = require('./authentication_store').Store
NotificationStore   = require('./notification_store').Store

Backend             = require('../adapters/backend')
{Notify}            = require('./notification_store').Actions

BudgetActions       = Reflux.createActions(["Open", "Close", "AddPayment", "AddShopping", "CloseShopping"])
BudgetStore = Reflux.createStore
  init: ->
    @budgets = new Immutable.List([])
    @ready   = false
    @backend = Backend

    @listenTo(AuthenticationStore, "authenticationChanged")
    @listenTo(NotificationStore, "notified")
    @listenTo(BudgetActions.Open,  "openBudget")
    @listenTo(BudgetActions.Close,  "closeBudget")
    @listenTo(BudgetActions.AddPayment, "addPayment")
    @listenTo(BudgetActions.AddShopping, "addShopping")
    @listenTo(BudgetActions.CloseShopping, "closeShopping")

  getInitialState: ->
    @data()

  data: ->
    new Immutable.Map(ready: @ready, budgets: @budgets)

  openBudget: (name) ->
    @backend.post('budget', budget: { name: name }).then (budgetJSON) =>
      @budgets = @budgets.concat(Immutable.fromJS([{ id: budgetJSON.budget_id, name: name, payments: [], shopping: [], closed: false }]))
      @trigger(@data())
      Notify(name: 'budgetCreated', arguments: [budgetJSON.budget_id, name])
    .fail =>
      Notify(name: 'budgetCreationFailed')

  closeBudget: (id) ->
    @backend.delete("budget/#{id}", true).then =>
      budgetName = null
      @budgets = @budgets.map (budget) =>
        if budget.get('id') is id
          budgetName = budget.get('name')
          budget.set('closed', true)
        else
          budget
      @trigger(@data())
      Notify(name: 'budgetClosed', arguments: [id, budgetName])
    .fail =>
      Notify(name: 'budgetClosingFailed')

  addPayment: (params) ->
    @backend.post("budget/#{params.budgetID}/payments", payment: { value: params.value }).then (paymentJSON) =>
      @budgets = @budgets.map (budget) =>
        if budget.get('id') is parseInt(params.budgetID)
          budget.set('payments', budget.get('payments')
            .concat(Immutable.fromJS([{ id: paymentJSON.payment_id, value: params.value, date: Date.create() }])))
        else
          budget
      @trigger(@data())
      Notify(name: 'paymentCreated', arguments: [params.budgetID])
    .fail =>
      Notify(name: 'paymentCreationFailed')

  addShopping: (budgetID) ->
    @backend.post("budget/#{budgetID}/shopping").then (shoppingJSON) =>
      @budgets = @budgets.map (budget) =>
        if budget.get('id') is parseInt(budgetID)
          budget.set('shopping', budget.get('shopping').concat(
            Immutable.fromJS([{ id: shoppingJSON.shopping_id, start_date: Date.create(), end_date: null, products: [] }])
          ))
        else
          budget
      @trigger(@data())
      Notify(name: 'shoppingCreated', arguments: [budgetID])
    .fail =>
      Notify(name: 'shoppingCreationFailed')

  closeShopping: (budgetID, shoppingID) ->
    @backend.delete("shopping/#{shoppingID}", true).then =>
      @budgets = @budgets.map (budget) =>
        if budget.get("id") is parseInt(budgetID)
          budget.set('shopping', budget.get('shopping').map (shopping) =>
            if shopping.get('id') is shoppingID
              shopping.set('end_date', Date.create())
            else
              shopping
          )
        else
          budget
      @trigger(@data())
      Notify(name: 'shoppingClosed')
    .fail =>
      Notify(name: 'shoppingCloseFailed')


  authenticationChanged: (authentication) ->
    if authentication
      @backend.authenticate(authentication)
      unless @ready
        @fetchBudgetsFromBackend()

  fetchBudgetsFromBackend: ->
    @backend.get('budgetoverview').then (budgetsJSON) =>
      @budgets = Immutable.fromJS(budgetsJSON.budgets).map((budget) =>
        budget.set('payments', budget.get('payments').map((payment) => payment.set('date', Date.create(payment.get('date')))))
      )
      @ready = true
      @trigger(@data())
      Notify(name: 'budgetsFetched')
    .fail =>
      Notify(name: 'budgetsFetchFailed')

  notified: (notification) ->
    switch notification.name
      when 'authenticated'
        @backend.authenticate(AuthenticationStore.getInitialState())
        @ready = false
        @trigger(@data())
        @fetchBudgetsFromBackend()
      when 'signedOut'
        @backend.authenticate(AuthenticationStore.getInitialState())
        @ready = false
        @trigger(@data())
        @fetchBudgetsFromBackend()

module.exports =
  Store: BudgetStore
  Actions: BudgetActions
