define [
  'backbone'
], (Backbone) ->
  class SessionsRouter extends Backbone.Router
    routes:
      "sessions/new": "login"
