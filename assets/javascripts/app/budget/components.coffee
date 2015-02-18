React = require('react')
Reflux = require('reflux')
{thead, tbody, th, div, h3, ul, li, span, nav, table, tr, td, a, p, button} = React.DOM
BudgetStore = require('../stores/budget_store').Store
{Close, AddShopping, CloseShopping} = require('../stores/budget_store').Actions

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

  onCloseShopping: (shoppingID) ->
    (ev) =>
      CloseShopping(@props.budgetID, shoppingID)

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
      thead
        key: "head"
        tr
          key: "title"
          th null, "#"
          th null, "Date"
          th null, "Value"
      tbody
        key: "body"
        @paymentsValues()
        tr
          key: "sum"
          td null, " "
          td null, " "
          td
            key: "sum value"
            "#{@paymentsSum()}"

  paymentsValues: ->
    index = 0
    for payment in @budget().payments
      index += 1
      tr
        key: payment.id
        td null, "#{index}"
        td null, "#{payment.date}"
        td null, "#{payment.value}"

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
          @shoppingTable()

  shoppingTable: ->
    table
      className: "table"
      thead
        key: "shoppingTableHead"
        tr
          key: "title"
          th null, "#"
          th null, "Start date"
          th null, "End date"
          th null, "Products"
      tbody
        key: "shoppingTableBody"
        @shoppingValues()

  shoppingValues: ->
    count = 0
    for shopping in @budget().shopping
      count += 1
      tr
        key: "shopping nr #{count}"
        td null, count
        td null,
          if shopping.start_date.format?
            shopping.start_date.format("{yyyy}-{MM}-{dd}")
          else
            shopping.start_date
        td
          key: "end_date#{count}"
          if shopping.end_date
            if shopping.end_date?.format?
              shopping.end_date.format("{yyyy}-{MM}-{dd}")
            else
              shopping.end_date
          else
            button
              onClick: @onCloseShopping(shopping.id)
              className: "btn btn-primary btn-xs"
              "Close shopping"
        td
          key: "button#{count}"
          div
            className: "dropdown"
            button
              className: "btn btn-default dropdown-toggle"
              id: "dropdownMenu#{shopping}"
              "Product list"
  paymentsSum: ->
    sum = 0
    for payment in @budget().payments
      sum += payment.value
    return sum
#  productList: (shopping) ->
#    ul
#      key: "ul#{shopping.start_date}"
#      className: "dropdown-menu"
#      htmlFor: "dropdownMenu#{shopping}"
#      for product in shopping.products
#        li
#          key: "key #{product.name}"
#          "#{product.name}"
module.exports = Budget