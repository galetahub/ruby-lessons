define [
  'backbone'
], (Backbone) ->
  class CateringRouter extends Backbone.Router
    routes:
      "sessions/new": "login"
      "contacts": "contacts"
      "sprints": "sprints"
