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
        @budgets()
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

  budgets: ->
    React.createElement(
      BudgetsLink
      key: 'budgetsLink'
    )

BudgetsLink = React.createClass
  displayName: 'Budgets Link'
  mixins: [Reflux.connect(BudgetStore, "budgets")]

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
      for budget in @state.budgets
        li
          key: "budget-#{budget.id}"
          a
            href: "#budget/#{budget.id}"
            budget.name
      li
        key: 'newBudget'
        a
          key: 'new'
          href: '#budget/new'
          "New Budget"

  render: ->
    li
      className: 'dropdown'
      @header()
      @elements()

module.exports = TopMenuComponent