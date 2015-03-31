define (require) ->
  View = require 'View'

  template = require 'hbars!templates/buttons'


  class ButtonsView extends View

    template: template

    events:
      'click @restore-to-default': 'preventDefault onClickRestore'

    onClickRestore: ->
      @publishEvent 'click:restore'