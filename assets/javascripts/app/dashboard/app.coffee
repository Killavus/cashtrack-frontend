React = require('react')
Gui = React.createFactory(require('./components'))

class App
  start: (node) =>
    React.render(Gui(), node)

module.exports = new App()