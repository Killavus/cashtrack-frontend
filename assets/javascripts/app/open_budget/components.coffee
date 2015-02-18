Reflux = require('reflux')
React  = require('react')
{Open} = require('../stores/budget_store').Actions

{div, label, input, p, button, h3} = React.DOM

NotificationStore = require('../stores/notification_store').Store

module.exports = React.createClass
  displayName: 'New Budget UI'
  mixins: [Reflux.ListenerMixin]

  getInitialState: ->
    name: ''
    submitting: false

  componentDidMount: ->
    @listenTo(NotificationStore, @handleCreationNotification)

  handleCreationNotification: (notification) ->
    switch notification.name
      when 'budgetCreationFailed'
        @setState submitting: false

  submittable: ->
    @state.name.length > 2 and not @state.submitting

  nameChanged: (event) ->
    @setState name: event.target.value

  nameClasses: ->
    classes = ['form-group']
    if @state.name.length > 0 and @state.name.length < 3
      classes.push('has-error')
    else
      classes.push('has-success') if @state.name
    classes.join(' ')

  nameValidationText: ->
    return "Name is required." unless @state.name
    return "Name is too short (3+ characters)." if @state.name.length > 0 and @state.name.length < 3
    return ""

  openNewBudget: ->
    @setState submitting: true
    Open(@state.name)

  render: ->
    div null,
      div
        className: 'panel panel-default'
        div
          key: 'header'
          className: 'panel-heading'
          h3
            key: 'header'
            className: 'panel-title'
            "Open Budget"
        div
          key: 'body'
          className: 'panel-body'
          div
            key: 'formBox'
            className: @nameClasses()
            label
              key: 'label'
              htmlFor: 'name'
              "Name: "
            input
              key: 'input'
              type: 'text'
              id: 'name'
              className: 'form-control'
              onChange: @nameChanged
              value: @state.name
            p({ key: 'validations', className: 'help-block' }, @nameValidationText()) if @nameValidationText()
        div
          key: 'footer'
          className: 'panel-footer'
          div
            className: 'pull-right'
            button
              key: 'action'
              className: 'btn btn-primary'
              disabled: not @submittable()
              onClick: @openNewBudget
              "Submit"
          div
            key: 'clearfix'
            style:
              clear: 'both'
            ""




