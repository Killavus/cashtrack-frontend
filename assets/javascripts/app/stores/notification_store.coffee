Reflux = require('reflux')

NotificationActions = Reflux.createActions(['Notify'])
NotificationStore = Reflux.createStore
  init: ->
    @listenTo(NotificationActions.Notify, "notify")

  notify: (notification) ->
    @trigger(notification)

module.exports =
  Store: NotificationStore
  Actions: NotificationActions