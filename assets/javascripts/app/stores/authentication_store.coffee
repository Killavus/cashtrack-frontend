Reflux = require('reflux')
Backend = require('../adapters/backend')
LocalStorage = require('../adapters/local_storage')

class UserAuthentication
  constructor: (@authenticationToken) ->
  token: => @authenticationToken
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
        when "user" then new UserAuthentication(@localStorage.get("authToken"))
        when "session" then new SessionAuthentication(@localStorage.get("authSessionID"), @localStorage.get("authSessionSecret"))
      @trigger(@authentication)

  signIn: (user, password) ->
    console.log('signIn', user, password)

  signOut: ->
    console.log('signOut')

  registerUser: (user, password) ->
    console.log('registerUser', user, password)

  getInitialState: ->
    @authentication

module.exports =
  Store: AuthenticationStore
  Actions: AuthenticationActions
