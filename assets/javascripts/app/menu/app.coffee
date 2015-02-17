React = require('react')
TopMenuComponent = React.createFactory(require('./components'))
NotificationStore = require('../stores/notification_store').Store
Flash = require('../utils/flash')

class App
  start: (node) ->
    React.render(TopMenuComponent(), node)

    NotificationStore.listen((notification) =>
      return if notification not in ['budgetsFetchFailed']

      @flash.error('Oops! There was an error while fetching budgets.')
    )

module.exports = new App()