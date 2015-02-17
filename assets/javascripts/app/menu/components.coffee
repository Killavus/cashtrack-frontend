React = require('react')
Reflux = require('reflux')
BudgetStore = require('../stores/budget_store').Store
NotificationStore = require('../stores/notification_store').Store

{div, button, span, a, ul, li} = React.DOM

TopMenuComponent = React.createClass
  displayName: 'Top Menu'
  mixins: [Reflux.ListenerMixin]

  render: ->
    @container(
      @header()
      @menuElements(
        @budgetsUI()
      )
    )

  container: (children...) ->
    div
      className: 'container-fluid'
      children...

  iconBars: ->
    [1,2,3].map (index) =>
      span
        key: "bar-#{index}"
        className: 'icon-bar'

  screenReaderText: ->
    span
      key: 'srOnlyText'
      className: 'sr-only'
      "Toggle Navigation"

  mobileNavigationButton: ->
    button
      key: 'mobileNavigation'
      type: 'button'
      className: "navbar-toggle collapsed"
      'data-toggle': 'collapse'
      'data-target': '#navbarMenu'
      @screenReaderText()
      @iconBars()

  menuElements: (children...) ->
    div
      key: 'menuElementsBox'
      className: 'collapse navbar-collapse'
      id: 'navbarMenu'
      ul
        key: 'menuElements'
        className: 'nav navbar-nav'
        children...

  headerBrand: ->
    a
      key: 'headerBrand'
      className: 'navbar-brand'
      href: '#'
      "CashTrack"

  header: ->
    div
      key: 'header'
      className: 'navbar-header'
      @mobileNavigationButton()
      @headerBrand()

  budgetsUI: ->
    React.createElement(
      BudgetsLink
      key: 'budgetsLink'
    )

BudgetsLink = React.createClass
  displayName: 'Budgets Link'
  mixins: [Reflux.ListenerMixin]


  onNotification: (notification) ->
    switch notification.name
      when 'budgetsFetchFailed'
        @setState errorInBudgets: true
      when 'budgetsFetchCompleted'
        @setState errorInBudgets: false

  getInitialState: ->
    ready: false
    errorInBudgets: false

  componentDidMount: ->
    @listenTo(BudgetStore, @onBudgetsChange)
    @listenTo(NotificationStore, @onNotification)

  onBudgetsChange: (budgetsData) ->
    @setState ready: budgetsData.get('ready'), budgets: budgetsData.get('budgets')

  budgets: ->
    @state.budgets.toJS()

  header: ->
    a
      key: 'header'
      href: '#'
      className: 'dropdown-toggle'
      'data-toggle': 'dropdown'
      role: 'button'
      'aria-expanded': 'false'
      "Budgets"
      span
        key: 'caret'
        className: 'caret'

  elements: ->
    ul
      className: 'dropdown-menu'
      key: 'elements'
      role: 'menu'
      for budget in @budgets()
        li
          key: "budget-#{budget.id}"
          a
            href: "#budget/#{budget.id}"
            budget.name
      li(key: 'split', className: 'divider') if @budgets().length
      li
        key: 'newBudget'
        a
          key: 'new'
          href: '#open_budget'
          "Open Budget"

  render: ->
    if @state.ready
      li
        className: 'dropdown'
        @header()
        @elements()
    else
      if @state.errorInBudgets
        li
          key: 'loading'
          a
            href: '#'
            style:
              textDecoration: 'line-through'
              color: 'red'
            "Budgets"
      else
        li
          key: 'loading'
          a
            href: '#'
            "Loading..."

module.exports = TopMenuComponent