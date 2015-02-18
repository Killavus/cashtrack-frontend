React = require('react')
{div, h3, p} = React.DOM

DashboardUI = React.createClass
  displayName: 'Home Page'

  render: ->
    div
      className: 'panel panel-default'
      div
        key: 'header'
        className: 'panel-heading'
        h3
          className: 'panel-title'
          "Hello!"
      div
        key: 'body'
        className: 'panel-body'
        p null,
          "To start, please open 'Budgets' menu at top of the page. You can there view your budgets and open new ones."

module.exports = DashboardUI