React = require('react')
Reflux = require('reflux')
BudgetStore = require('../stores/budget_store').Store
NotificationStore = require('../stores/notification_store').Store
AuthenticationStore = require('../stores/authentication_store').Store
{SignIn, SignOut, Register} = require('../stores/authentication_store').Actions

{div, button, span, a, ul, li, h3, label, button, input, strong, p} = React.DOM

TopMenuComponent = React.createClass
  displayName: 'Top Menu'
  mixins: [Reflux.ListenerMixin]

  render: ->
    @container(
      @header()
      @authenticationControls()
      @menuElements(
        @budgetsUI()
      )
    )

  authenticationControls: ->
    React.createElement(
      AuthenticationControls
      key: 'authenticationControls'
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

  budgetsDropdown: ->
    li
      className: 'dropdown'
      @header()
      @elements()

  errorneusFetch: ->
    li
      key: 'errorneus-fetch'
      a
        href: '#'
        style:
          textDecoration: 'line-through'
          color: 'red'
        "Budgets"

  loading: ->
    li
      key: 'loading'
      a
        href: '#'
        "Loading..."

  render: ->
    if @state.ready
      @budgetsDropdown()
    else
      if @state.errorInBudgets
        @errorneusFetch()
      else
        @loading()

AuthenticationControls = React.createClass
  displayName: 'Authentication Controls'
  mixins: [Reflux.ListenerMixin]

  getInitialState: ->
    login: ''
    password: ''
    signInSubmitting: false

  componentDidMount: ->
    @listenTo(AuthenticationStore, @authenticationChanged)
    @listenTo(NotificationStore, @onNotification)

  onNotification: (notification) ->
    switch notification.name
      when 'authenticated'
        @setState signInSubmitting: false
      when 'authenticationFailed'
        @setState signInSubmitting: false

  authenticationChanged: (authentication) ->
    @setState authentication: authentication

  onSignOut: ->
    SignOut()

  onSignIn: ->
    SignIn(login: @state.login, password: @state.password)
    @setState signInSubmitting: true

  onLoginChange: (ev) ->
    @setState login: ev.target.value

  onPasswordChange: (ev) ->
    @setState password: ev.target.value

  signOutForm: ->
    [
      div
        key: 'formBox'
        className: 'form-group'
        p
          key: 'greeting'
          "Hello, "
          strong
            key: 'userName'
            @state.authentication.login()
          "\u2003"
          button
            key: 'signOutButton'
            onClick: @onSignOut
            className: 'btn btn-danger'
            "Sign Out"
    ]

  signInForm: ->
    [
      div
        key: 'formBox'
        className: 'form-group'
        input
          key: 'loginField'
          type: 'text'
          placeholder: 'Login'
          className: 'form-control'
          onChange: @onLoginChange
          value: @state.login
        " "
        input
          key: 'passwordField'
          type: 'password'
          placeholder: 'Password'
          className: 'form-control'
          onChange: @onPasswordChange
          value: @state.password
        " "
        button
          key: 'signInButton'
          className: 'btn btn-primary'
          onClick: @onSignIn
          disabled: @state.signInSubmitting
          if @state.signInSubmitting
            "Signing in..."
          else
            "Sign in"
    ]

  registerButton: ->
    [
      " "
      a
        key: 'registerButton'
        className: 'btn'
        href: '#register'
        "Register"
    ]


  render: ->
    div
      className: 'navbar-form navbar-right'
      if @state.authentication
        if @state.authentication.isUserAuth()
          @signOutForm()
        else
          [
            @signInForm()
            @registerButton()
          ]
      else
        label
          key: 'loadingLabel'
          "Loading..."

module.exports = TopMenuComponent