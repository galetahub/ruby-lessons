define [
  'underscore'
  'backbone'
], (_, Backbone) ->
  'use strict';

  class SessionModel extends Backbone.Model
    url: '/sessions'

    initialize: () ->
      self = this
      
      $.ajaxPrefilter( (options, originalOptions, jqXHR) ->
        options.xhrFields =
          withCredentials: true
        
        if self.get('auth_token')?
          jqXHR.setRequestHeader('X-Auth-Token', self.get('auth_token'))
      )

    defaults: {}

    login: (params) ->
      this.save(params, 
        success: (model, response) ->
          console.log model
        error: (model, response) ->
          console.log model, response
      )

      # Just for testing
      this.set({auth: true, auth_token: 'test', name: 'Ivan Dron'})

    logout: (params) ->
      self = this

      this.destroy(
        success: (model, response) ->
          model.clear()
          model.id = null

          self.set({auth: false, auth_token: null, name: null})
      )

    getAuth: (callback) ->
      this.fetch(
        success: callback
      )

  return new SessionModel()
    