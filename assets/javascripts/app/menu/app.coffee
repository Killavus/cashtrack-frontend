React = require('react')
TopMenuComponent = React.createFactory(require('./components'))
NotificationStore = require('../stores/notification_store').Store
Flash = require('../utils/flash')

class App
  constructor: ->
    @notificationsEnabled = false

  start: (node) ->
    @flash = new Flash()
    React.render(TopMenuComponent(), node)

    unless @notificationsEnabled
      NotificationStore.listen((notification) =>
        switch notification.name
          when 'budgetsFetchFailed'
            @flash.error('Oops! There was an error while fetching budgets.')
          when 'budgetsFetched'
            @flash.success('Your budgets are loaded. Hell yeah!')
      )
      @notificationsEnabled = true

module.exports = new App()