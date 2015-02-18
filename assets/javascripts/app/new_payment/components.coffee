React = require('react')
{AddPayment} = require('../stores/budget_store').Actions

{div, label, input, p, button, h3, a} = React.DOM

module.exports = React.createClass
  displayName: 'Add Payment UI'

  getInitialState: ->
    name: ''
    submitting: false
    value: 0

  handleCreationNotification: (notification) ->
    switch notification.name
      when 'paymentCreationFailed'
        @setState submitting: false

  submittable: ->
    @state.value > 0 and not @state.submitting

  valueChanged: (event) ->
    @setState value: parseFloat(event.target.value)

  valueClasses: ->
    classes = ['form-group']
    classes.push('has-success') if @state.value > 0
    classes.join(' ')

  valueValidationText: ->
    ""

  addNewPayment: ->
    @setState submitting: true
    AddPayment(budgetID: @props.budgetID, value: @state.value)

  render: ->
    div null,
      div
        className: 'panel panel-default'
        div
          key: 'header'
          className: 'panel-heading'
          div
            key: 'actionBox'
            className: 'pull-right'
            a
              href: "#budget/#{@props.budgetID}"
              className: 'btn btn-xs btn-info'
              "Back"
          h3
            key: 'header'
            className: 'panel-title'
            "Add Payment"
        div
          key: 'body'
          className: 'panel-body'
          div
            key: 'formBox'
            className: @valueClasses()
            label
              key: 'label'
              htmlFor: 'value'
              "Value: "
            input
              key: 'input'
              type: 'number'
              min: 0
              id: 'value'
              className: 'form-control'
              onChange: @valueChanged
              value: @state.value
            p({ key: 'validations', className: 'help-block' }, @valueValidationText()) if @valueValidationText().length
        div
          key: 'footer'
          className: 'panel-footer'
          div
            className: 'pull-right'
            button
              key: 'action'
              className: 'btn btn-primary'
              disabled: not @submittable()
              onClick: @addNewPayment
              "Submit"
          div
            key: 'clearfix'
            style:
              clear: 'both'
            ""