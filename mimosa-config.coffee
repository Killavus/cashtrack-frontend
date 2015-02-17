exports.config =
  modules: [
    "server"
    "browserify"
    "jshint"
    "csslint"
    "live-reload"
    "bower"
    "coffeescript"
    "copy"]
  server:
    defaultServer:
      onePager: true
    views:
      compileWith: 'html'
      path: 'public'
  browserify:
    bundles:
      [
        entries: ['javascripts/main.js']
        outputFile: 'bundle.js'
      ]
    shims:
      jquery:
        path: 'javascripts/vendor/jquery/jquery'
        exports: '$'
      react:
        path: 'javascripts/vendor/react/react'
        exports: 'React'
      reflux:
        path: 'javascripts/vendor/reflux/reflux'
        exports: 'Reflux'
      underscore:
        path: 'javascripts/vendor/underscore/underscore'
        exports: '_'
      backbone:
        path: 'javascripts/vendor/backbone/backbone'
        exports: 'Backbone'
      simplestorage:
        path: 'javascripts/vendor/simpleStorage/simpleStorage'
        exports: 'simpleStorage'
