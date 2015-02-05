Reflux = require('reflux')

BudgetActions = Reflux.createActions(["Open", "Close"])

BudgetStore = Reflux.createStore
  init: ->
    @counter = 4
    @budgets = @exampleBudgets()
    @listenTo(BudgetActions.Open, "openBudget")
    @listenTo(BudgetActions.Close, "closeBudget")

  getInitialState: ->
    @budgets

  openBudget: (connection, name) ->
    @budgets = @budgets.concat([{ id: @counter++, name: name }])
    @trigger(@budgets)

  closeBudget: (connection, budgetID) ->


  exampleBudgets: ->
    [
      {
        id: 1,
        name: 'Budget #1'
      },
      {
        id: 2,
        name: 'Budget #2'
      },
      {
        id: 3,
        name: 'Budget #3'
      }
    ]

module.exports =
  Store: BudgetStore
  Actions: BudgetActions
