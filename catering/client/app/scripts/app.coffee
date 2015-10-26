define [
  'jquery',
  'underscore',
  'backbone',
  'router'
], ($, _, Backbone, Router) ->
  _initialize = () ->
    _router = new Router()

    _router.on 'route:login', (page) ->
      console.log('login')
     
    Backbone.history.start()

  return {
    initialize: _initialize
  }