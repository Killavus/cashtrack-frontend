React = require('react')
Flash = require('../utils/flash')
Gui = React.createFactory(require('./components'))

class BudgetApp
  constructor: ->
    @notificationsRegistered = false

  start: (node, id) =>
    @flash = new Flash()
    React.render(Gui(budgetID: id),node)


module.exports = new BudgetApp()
