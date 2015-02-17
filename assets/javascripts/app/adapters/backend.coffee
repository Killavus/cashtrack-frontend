$ = require 'jquery'

class AuthenticationDataSerializer
  constructor: (@apiRoot, @authentication) ->

  serialize: (parameters) =>
    parameters.url = [@apiRoot, parameters.url].join('/')
    parameters.data = JSON.stringify(parameters.data) if parameters.data?
    parameters.headers = Object.merge(parameters.headers or {}, @authenticationHeaders())
    parameters

  authenticationHeaders: =>
    ({
      true: @userAuthHeaders
      false: @sessionAuthHeaders
    }[@authentication.isUserAuth()])()

  userAuthHeaders: =>
    'X-Authentication-Token': @authentication.token()

  sessionAuthHeaders: =>
    'X-Session-Id': @authentication.sessionID()
    'X-Session-Secret': @authentication.sessionSecret()

class PlainDataSerializer
  constructor: (@apiRoot) ->

  serialize: (parameters) =>
    parameters.url = [@apiRoot, parameters.url].join('/')
    parameters.data = JSON.stringify(parameters.data)
    parameters

class BackendAdapter
  constructor: ->

  setApiRoot: (@apiRoot) =>
    @serializer = new PlainDataSerializer(@apiRoot)

  authenticate: (authentication) ->
    return unless authentication
    @serializer = new AuthenticationDataSerializer(@apiRoot, authentication)

  prepare: (parameters) =>
    @serializer.serialize(parameters)

  get: (url) =>
    $.ajax @prepare(
      url: url
      type: 'GET'
      dataType: 'JSON'
      contentType: 'application/json'
    )

  post: (url, data) =>
    $.ajax @prepare(
      url: url
      type: 'POST'
      dataType: 'JSON'
      contentType: 'application/json'
      data: data
      processData: false
    )

  update: (url, data) =>
    $.ajax @prepare(
      url: url
      type: 'PUT'
      dataType: 'JSON'
      contentType: 'application/json'
      data: data
      processData: false
    )

  delete: (url) =>
    $.ajax @prepare(
      url: url
      type: 'DELETE'
      dataType: 'JSON'
      contentType: 'application/json'
      data: data
      processData: false
    )

module.exports = new BackendAdapter()

