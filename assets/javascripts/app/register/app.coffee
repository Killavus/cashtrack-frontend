React = require('react')
Gui = React.createFactory(require('./components'))
NotificationStore = require('../stores/notification_store').Store
Flash = require('../utils/flash')

class App
  constructor: ->
    @notificationEnabled = false

  start: (node) =>
    React.render(Gui(), node)
    @flash = new Flash()

    unless @notificationEnabled
      NotificationStore.listen((notification) =>
        switch notification.name
          when 'registered'
            @flash.success('Successfully registered. Enjoy!')
          when 'registrationFailed'
            @flash.error('There was an error during registration. Bummer!')
      )
      @notificationEnabled = true

module.exports = new App()