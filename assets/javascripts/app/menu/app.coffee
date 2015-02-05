React = require('react')
TopMenuComponent = React.createFactory(require('./components'))

class App
  start: (node) ->
    React.render(TopMenuComponent(), node)

module.exports = App