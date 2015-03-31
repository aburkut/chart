define (require) ->
  View = require 'View'

  template = require 'hbars!templates/tooltip'


  class TooltipView extends View

    template: template

    initialize: (options) ->
      @point = options.point


    serialize: ->
      isForecast = @point.point.options.name is 'Forecast'
      opexGb = @point.point.options.opexGb
      capexGb = @point.point.options.capexGb

      type: if isForecast then 'Forecast' else 'Current'
      color: if isForecast then '#DE2B38' else '#60baea'
      tb: @tbFormatter(@point.y)
      opex: @kFormatter(opexGb * @point.y)
      capex: @kFormatter(capexGb * @point.y)
      month: @point.x


    kFormatter: (num) ->
      if num > 999 then (num / 1000).toFixed(1) + 'K' else num


    tbFormatter: (num) ->
      if num > 1024 then (num / 1024).toFixed() else num