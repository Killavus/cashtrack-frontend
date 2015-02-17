React = require('react')
Gui = React.createFactory(require('./components'))
Flash = require('../utils/flash')
NotificationStore = require('../stores/notification_store').Store

class App
  constructor: ->
    @notificationsRegistered = false

  start: (node) =>
    @flash = new Flash()
    React.render(Gui(), node)

    unless @notificationsRegistered
      NotificationStore.listen((notification) =>
        return if notification.name not in ['budgetCreated', 'budgetCreationFailed']

        switch notification.name
          when 'budgetCreated'
            name = notification.arguments[1]
            @flash.success("Success! Budget named #{name} created successfully.")
          when 'budgetCreationFailed'
            @flash.error("Oops! Creation of new budget failed.")
      )
      @notificationsRegistered = true

module.exports = new App()