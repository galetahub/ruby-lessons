define [
  'jquery',
  'underscore',
  'backbone',
  'router',

  'models/session'

  'views/contacts',
  'views/login',
  'views/sprints'
], ($, _, Backbone, Router, Session, ContactsView, LoginView, SprintsView) ->
  class Application
    @defaults = 
      api_endpoint: "http://127.0.0.1:3000/api"

    constructor: (options = {}) ->
      @router = null
      @options = $.extend(Application.defaults, options)

    initialize: () ->
      this._initConfiguration()
      this._initRoutes()
      this._initEvents()
    
    _initConfiguration: ->
      self = this

      $.ajaxPrefilter((options, originalOptions, jqXHR) ->
        options.url = "#{self.options.api_endpoint}/#{options.url}"
      )

    _initRoutes: ->
      @router = new Router()

      @router.on 'route:login', (page) ->
        _view = new LoginView()
        _view.render()

      @router.on 'route:contacts', (page) ->
        _view = new ContactsView()
        _view.render()

      @router.on 'route:sprints', (page) ->
        _view = new SprintsView()
        _view.render()

      Backbone.history.start()

    _initEvents: ->
      self = this

      Session.on 'change:auth', (session) ->
        self.checkAuth()

      # Check if user already logined
      Session.getAuth(callback)

    checkAuth: ->
      if Session.get('auth') is true
        @router.navigate("sprints", {trigger: true})
      else
        @router.navigate("contacts", {trigger: true})

  return new Application()
