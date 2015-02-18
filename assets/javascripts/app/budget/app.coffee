React = require('react')
Flash = require('../utils/flash')
Gui = React.createFactory(require('./components'))
NotificationStore = require('../stores/notification_store').Store

class BudgetApp
  constructor: ->
    @notificationsRegistered = false

  start: (node, id) =>
    @flash = new Flash()
    React.render(Gui(budgetID: id),node)

    unless @notificationsRegistered
      NotificationStore.listen((notification) =>
        switch notification.name
          when 'budgetClosed'
            name = notification.arguments[1]
            @flash.success("Successfully closed budget named #{name}!")
          when 'budgetClosingFailed'
            @flash.error('Oops! Failed to close budget!')
          when 'shoppingCreated'
            @flash.success("Successfully created shopping!")
          when 'shoppingCreationFailed'
            @flash.error('Shopping creation failed. What a joke!')
      )


module.exports = new BudgetApp()
