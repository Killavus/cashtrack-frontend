React = require('react')
{div} = React.DOM

FlashView = React.createClass
  displayName: 'FlashView'
  getInitialState: ->
    messages: []
  display: (message) ->
    message._id = new Date().getTime()
    @setState messages: @state.messages.concat([message])
    setTimeout @hide.bind(@, message), 5000
  hide: (message) ->
    @setState messages: @state.messages.exclude(message)
  render: ->
    div
      className: 'flashes'
      for message in @state.messages
        div
          key: message._id
          className: "alert alert-#{message.type} fade in"
          message.message

class Flash
  constructor: ->
    FlashUI = React.createFactory(FlashView)
    @flash = React.render(FlashUI(), document.querySelector('[role=flash-container]').appendChild(document.createElement('div')))
  display: (message) ->
    @flash.display(message)
  success: (message) ->
    @flash.display(type: 'success', message: message)
  error: (message) ->
    @flash.display(type: 'danger', message: message)

module.exports = Flash