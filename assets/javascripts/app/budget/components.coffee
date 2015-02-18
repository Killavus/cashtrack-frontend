React = require('react')
Reflux = require('reflux')
{div, h3, ul, li, span, nav, table, tr, td, a, p, button} = React.DOM
BudgetStore = require('../stores/budget_store').Store
{Close, AddShopping} = require('../stores/budget_store').Actions

Budget = React.createClass
  mixins: [Reflux.ListenerMixin]

  getInitialState: ->
    closingBudget: false
    closed: false

  onClose: ->
    Close(@props.budgetID)

  onCloseCanceled: ->
    @setState closingBudget: false

  onClosingBudget: ->
    @setState closingBudget: true

  onAddShopping: ->
    AddShopping(@props.budgetID)

  render: ->
    if @state.ready
      div
        key: "body"
        @budgetInfo()
    else
      div null, "loading..."

  getInitialState: ->
    ready: false

  componentDidMount: ->
    @listenTo(BudgetStore, @onBudgetsUpdate, @onBudgetsUpdate)

  onBudgetsUpdate: (budgetData) ->
    @setState(ready: budgetData.get('ready'), budgets: budgetData.get('budgets'))

  budget: ->
    @state.budgets.toJS().find (budget) => budget.id is parseInt(@props.budgetID)

  budgetInfo: ->
    div
      className: "panel panel-default"
      div
        key: "header"
        className: "panel-heading"
        div
          className: "pull-right"
          if @budget().closed
            p
              key: 'closed'
              style:
                color: 'red'
                fontWeight: 'bold'
              "Closed!"
          else
            if @state.closingBudget
              p
                key: 'confirm'
                "Are you sure?"
                "\u2003"
                button
                  onClick: @onClose
                  className: 'btn btn-danger btn-xs'
                  "Yes"
                "\u2003"
                button
                  onClick: @onCloseCanceled
                  className: 'btn btn-xs'
                  "No"
            else
              button
                onClick: @onClosingBudget
                className: "btn btn-danger btn-xs"
                "Close budget"
        h3
          className: "panel-title"
          @budget().name
      div
        key: "content"
        className: "panel-body"
        @shoppingInfo()
        @paymentsInfo()

  paymentsInfo: ->
    div
      className: "col-md-4 col-md-offset-1"
      div
        className: "panel panel-default"
        div
          key: "PaymentsHeader"
          className: "panel-heading"
          unless @budget().closed
            div
              className: "pull-right"
              a
                href: "#budget/#{@budget().id}/add_payment"
                className: "btn btn-primary btn-xs"
                "Add Payment"
          h3
            className: "panel-title"
            "Payments"
        div
          key: "PaymentsContent"
          className: "panel-body"
          @paymentsTable()

  paymentsTable: ->
    table
      className: "table"
      tr
        key: "title"
        td null, "#"
        td null, "Date"
        td null, "Value"
      @paymentsValues()

  paymentsValues: ->
    index = 1
    for payment in @budget().payments
      tr
        className: "tr #{payment}"
        td null, index
        td null, payment.date
        td null, payment.value
      index = index + 1

  shoppingInfo: ->
    div
      className: "col-md-7"
      div
        className: "panel panel-default"
        div
          key: "PaymentsHeader"
          className: "panel-heading"
          unless @budget().closed
            div
              className: "pull-right"
              button
                onClick: @onAddShopping
                className: "btn btn-primary btn-xs"
                "Add Shopping"
          h3
            className: "panel-title"
            "Shopping"
        div
          key: "PaymentsContent"
          className: "panel-body"
          "koczkoczkodan"
module.exports = Budget