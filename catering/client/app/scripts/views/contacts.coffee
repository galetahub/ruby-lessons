define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class ContactsView extends Backbone.View
    template: JST['app/scripts/templates/contacts.hbs']

    el: '#container'

    events:
      'click button.contact': 'contact'

    initialize: () ->
      # @listenTo @model, 'change', @render

    render: () ->
      @$el.html @template({phone: "+380971234567"})

    contact: () ->
      alert('Hi')
