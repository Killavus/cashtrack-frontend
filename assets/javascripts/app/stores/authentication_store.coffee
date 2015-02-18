Reflux = require('reflux')
Backend = require('../adapters/backend')
LocalStorage = require('../adapters/local_storage')
{Notify} = require('./notification_store').Actions

class UserAuthentication
  constructor: (@authenticationToken, @userLogin) ->
  token: => @authenticationToken
  login: => @userLogin
  isUserAuth: => true

class SessionAuthentication
  constructor: (@id, @secret) ->
  sessionID: => @id
  sessionSecret: => @secret
  isUserAuth: => false

AuthenticationActions = Reflux.createActions(["Register", "SignIn", "SignOut"])
AuthenticationStore = Reflux.createStore
  init: ->
    @localStorage = new LocalStorage()
    @authentication = null

  start: ->
    @backend = Backend
    @establishLocalStorageCredentials()
    @requestNewSession() unless @authentication

    @listenTo(AuthenticationActions.Register, "registerUser")
    @listenTo(AuthenticationActions.SignIn, "signIn")
    @listenTo(AuthenticationActions.SignOut, "signOut")

  requestNewSession: ->
    @backend.post('sessions').then (sessionJSON) =>
      @localStorage.set('authType', 'session')
      @localStorage.set('authSessionID', sessionJSON.session_id)
      @localStorage.set('authSessionSecret', sessionJSON.secret)
      @establishLocalStorageCredentials()

  establishLocalStorageCredentials: ->
    if type = @localStorage.get('authType')
      @authentication = switch type
        when "user" then new UserAuthentication(@localStorage.get("authToken"),
                                                @localStorage.get("authLogin"))
        when "session" then new SessionAuthentication(@localStorage.get("authSessionID"), @localStorage.get("authSessionSecret"))
      @trigger(@authentication)

  signIn: (params) ->
    @backend.post('authentication', user: { email: params.login, password: params.password }, true).then (authTokenJSON) =>
      @localStorage.set('authType', "user")
      @localStorage.set('authLogin', params.login)
      @localStorage.set('authToken', authTokenJSON.token_key)

      secret = @localStorage.get("authSessionSecret")
      id = @localStorage.get("authSessionID")

      @localStorage.delete('authSessionID')
      @localStorage.delete('authSessionSecret')

      @establishLocalStorageCredentials()

      @backend.get('authentication').then (userJSON) =>
        userID = userJSON.id
        @backend.post('sessions/link_with_user', session_id: id, session_secret: secret, user_id: userID, true).then =>
          @backend.authenticate(@authentication)
          @trigger(@authentication)
          Notify(name: 'authenticated')
        .fail =>
          @fallBackToSession(id, secret)
          Notify(name: 'authenticationFailed')
      .fail =>
        @fallBackToSession(id, secret)
        Notify(name: 'authenticationFailed')
    .fail =>
      Notify(name: 'authenticationFailed')

  fallBackToSession: ->
    @localStorage.set('authType', "session")
    @localStorage.set('authSessionID', id)
    @localStorage.set('authSessionSecret', secret)
    @localStorage.delete('authLogin')
    @localStorage.delete('authToken')
    @establishLocalStorageCredentials()

  signOut: ->
    @localStorage.delete("authType")
    @localStorage.delete("authLogin")
    @localStorage.delete("authToken")
    @requestNewSession()
    @establishLocalStorageCredentials()
    Notify(name: 'signedOut')


  registerUser: (params) ->
    @backend.post('users', user: { email: params.email, password: params.password }, true).then =>
      Notify(name: 'registered')
      AuthenticationActions.SignIn(login: params.email, password: params.password)
    .fail =>
      Notify(name: 'registrationFailed')

  getInitialState: ->
    @authentication

module.exports =
  Store: AuthenticationStore
  Actions: AuthenticationActions
