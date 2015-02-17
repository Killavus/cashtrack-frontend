React = require('react')
Reflux = require('reflux')
BudgetStore = require('../stores/budget_store').Store

{div, button, span, a, ul, li} = React.DOM

TopMenuComponent = React.createClass
  displayName: 'Top Menu'

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

  getInitialState: ->
    ready: false

  componentDidMount: ->
    @listenTo(BudgetStore, @onBudgetsChange)

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
      li
        key: 'newBudget'
        a
          key: 'new'
          href: '#new_budget'
          "New Budget"

  render: ->
    if @state.ready
      li
        className: 'dropdown'
        @header()
        @elements()
    else
      li
        key: 'loading'
        a
          href: '#'
          "Loading..."

module.exports = TopMenuComponent