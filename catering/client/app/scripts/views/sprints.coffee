define [
  'jquery'
  'underscore'
  'backbone'
  'templates'

  'views/panel'
], ($, _, Backbone, JST, PanelView) ->
  class SprintsView extends Backbone.View
    template: JST['app/scripts/templates/sprints.hbs']

    el: '#container'

    panel: new PanelView()

    events: {}

    initialize: () ->
      # @listenTo @model, 'change', @render

    render: () ->
      @$el.html @template()

      @panel.$el = @$('#user_panel')
      @panel.render()
      @panel.delegateEvents()

