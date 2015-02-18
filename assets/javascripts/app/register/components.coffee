Reflux = require('reflux')
React = require('react')

{Register} = require('../stores/authentication_store').Actions
AuthenticationStore = require('../stores/authentication_store').Store
NotificationStore = require('../stores/notification_store').Store
{div, label, input, button, h3, p} = React.DOM

RegisterForm = React.createClass
  displayName: 'Register Form'
  mixins: [Reflux.ListenerMixin]

  getInitialState: ->
    email: ''
    password: ''
    passwordRepeat: ''
    submitting: false

  componentDidMount: ->
    @listenTo(AuthenticationStore, @authenticationChanged)
    @listenTo(NotificationStore, @onNotification)

  onNotification: (notification) ->
    switch notification.name
      when 'registered'
        @setState submitting: false
      when 'registrationFailed'
        @setState submitting: false

  onRegister: ->
    @setState submitting: true
    Register(email: @state.email, password: @state.password)

  authenticationChanged: (authentication) ->
    @setState authentication: authentication

  signedIn: ->
    @state.authentication and @state.authentication.isUserAuth()

  submittable: ->
    @state.email.indexOf('@') isnt -1 and @state.password is @state.passwordRepeat and @state.password.length > 3 and
      @state.password.length and @state.email.length and not @state.submitting

  emailClasses: ->
    classes = ['form-group']
    classes.push('has-error') if @state.email.indexOf('@') is -1 and @state.email.length
    classes.push('has-success') if @state.email.length and @state.email.indexOf('@') isnt -1
    classes.join(' ')

  passwordsClasses: ->
    classes = ['form-group']
    classes.push('has-error') if @state.password.length and (@state.password.length < 4 or @state.password isnt @state.passwordRepeat)
    classes.push('has-success') if @state.password.length > 3 and @state.password is @state.passwordRepeat
    classes.join(' ')

  emailValidationText: ->
    return "E-mail is required." unless @state.email.length
    return "E-mail must be valid." if @state.email.indexOf('@') is -1
    ""

  passwordsValidationText: ->
    return "Password is required." unless @state.password.length
    return "Password is too short. (4+ characters)" if @state.password.length < 4
    return "Passwords must match." if @state.password isnt @state.passwordRepeat
    ""

  emailChanged: (ev) ->
    @setState email: ev.target.value

  passwordChanged: (ev) ->
    @setState password: ev.target.value

  passwordRepeatChanged: (ev) ->
    @setState passwordRepeat: ev.target.value

  render: ->
    div
      className: 'panel panel-default'
      div
        key: 'header'
        className: 'panel-heading'
        h3 className: 'panel-title', "Register"
      div
        key: 'body'
        className: 'panel-body'
        if @signedIn()
          div
            key: 'alert'
            className: 'alert alert-warning'
            "You are already registered and signed in."
        else
          div
            key: 'form'
            div
              key: 'formBoxEmail'
              className: @emailClasses()
              label
                key: 'emailLabel'
                htmlFor: 'email'
                "E-mail: "
              input
                key: 'emailField'
                type: 'text'
                id: 'email'
                onChange: @emailChanged
                className: 'form-control'
                value: @state.email
              p({ key: 'validations', className: 'help-block' }, @emailValidationText()) if @emailValidationText().length
            div
              key: 'formBoxPasswords'
              className: @passwordsClasses()
              label
                key: 'passwordLabel'
                htmlFor: 'password'
                "Password: "
              input
                type: 'password'
                key: 'passwordField'
                id: 'password'
                onChange: @passwordChanged
                className: 'form-control'
                value: @state.password
              label
                key: 'passwordRepeatLabel'
                htmlFor: 'passwordRepeat'
                "Repeat Password: "
              input
                type: 'password'
                key: 'passwordRepeatField'
                id: 'passwordRepeat'
                onChange: @passwordRepeatChanged
                className: 'form-control'
                value: @state.passwordRepeat
              p({ key: 'validations', className: 'help-block' }, @passwordsValidationText()) if @passwordsValidationText().length
      unless @signedIn()
        div
          key: 'footer'
          className: 'panel-footer'
          div
            key: 'actionBox'
            className: 'pull-right'
            button
              disabled: not @submittable()
              onClick: @onRegister
              className: 'btn btn-primary'
              "Submit"
          div
            key: 'clearfix'
            style:
              clear: 'both'

module.exports = RegisterForm



