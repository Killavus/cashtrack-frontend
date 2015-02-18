NotificationStore = require('../stores/notification_store').Store
Flash = require('../utils/flash')
Gui = require('./components')
class App
  constructor: ->
    @notificationsEnabled = false

  start: (node, budgetID) =>
    React.render(Gui(budgetID: budgetID), node)
    @flash = new Flash()

    unless @notificationsEnabled
      NotificationStore.listen((notification) =>
        switch notification.name
          when 'paymentCreated'
            @flash.success("Payment added successfully. Enjoy your cash!")
          when 'paymentCreationFailed'
            @flash.error("Payment creation failed.")
      )
      @notificationsEnabled = true

module.exports = new App()