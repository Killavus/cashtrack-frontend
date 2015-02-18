React = require('react')
Reflux = require('reflux')
{div, h3, ul, li, span, nav, table, tr, td, a} = React.DOM
BudgetStore = require('../stores/budget_store').Store


Budget = React.createClass
  mixins: [Reflux.ListenerMixin]

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
    @listenTo(BudgetStore, @onBudgetsUpdate)

  onBudgetsUpdate: (budgetData) ->
    @setState(ready: budgetData.get('ready'), budgets: budgetData.get('budgets'))

  budget: ->
    @state.budgets.toJS().find (budget) => budget.id is parseInt(@props.budgetID)

  budgetClosed: ->
    div
      className: "pull-right"
      h3
        key: "closed"
        "Closed?"
        @budgetClosedColorSpan()

  budgetClosedColorSpan: ->
    if !@budget().closed
      span
        className: "label label-success"
        "NO"
    else
      span
        className: "label label-warning"
        "YES"


  budgetInfo: ->
    div
      className: "panel panel-default"
      div
        key: "header"
        className: "panel-heading"
        div
          className: "pull-right"
          a
            href: "#budget/#{@budget().id}/close"
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
          div
            className: "pull-right"
            a
              href: "#budget/#{@budget().id}/add_payment"
              className: "btn btn-primary btn-xs"
              "Add Payment"
          h3
            className: "panel-title"
            "About Payments"
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
          div
            className: "pull-right"
            a
              href: "#budget/#{@budget().id}/add_shopping"
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