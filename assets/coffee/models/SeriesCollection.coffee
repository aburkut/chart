define (require) ->
  Collection = require 'Collection'
  SeriesModel = require 'models/SeriesModel'
  _  = require '_'
  utils = require 'utils'


  class SeriesCollection extends Collection

    forecastColor: '#DE2B38'

    currentColor: '#60baea'

    currentSymbol: 'diamond'

    forecastSymbol: 'circle'

    forecastIndex: 1.0167

    typeForecast: 'Forecast'

    typeCurrent: 'Current'

    types: []

    model: SeriesModel

    reset: (models, options) ->
      super models, options
      @defaultModels = _.clone models
      @generateForecastModels()


    updateHigherModels: (seriesModel) ->
      higherModels = _.filter @models, (model) =>
        model.get('type') is @typeForecast and model.get('id') > seriesModel.get 'id'

      _.each higherModels, (model, key) =>
        prevModel = if higherModels[key - 1] then higherModels[key - 1] else seriesModel
        model.set 'gb', prevModel.get('gb') * @forecastIndex
        model.set 'capexGb', prevModel.get('capexGb') * @forecastIndex
        model.set 'opexGb', prevModel.get('opexGb') * @forecastIndex


    generateForecastModels: ->
      length = @length

      for i in [1..length]
        lastModel = @at([@length - 1])
        maxIdModel = _.max @models, (model) ->
          model.get 'id'

        @add
          id: +maxIdModel.get('id') + 1
          type: @typeForecast
          gb: Math.round lastModel.get('gb') * @forecastIndex
          capexGb: lastModel.get('capexGb') * @forecastIndex
          opexGb: lastModel.get('opexGb') * @forecastIndex
          month: @at(i - 1).get 'month'


    getChartOptions: ->
      lastCurrentIndex = @length / 2 - 1
      result =
        categories: []
        data: []

      @each (model, key) =>
        result.categories.push model.get 'month'
        segmentColor = if key is lastCurrentIndex then @forecastColor else false
        result.data.push @seriesFormat(model, segmentColor)

      result


    getDefaultChartOptions: ->
      @reset @defaultModels
      @getChartOptions()


    seriesFormat: (model, segmentColor = false) ->
      isForecast = model.isForecast()
      color = if isForecast then @forecastColor else @currentColor

      id: model.get 'id'
      name: if isForecast then @typeForecast else  @typeCurrent
      opexGb: model.get 'opexGb'
      capexGb: model.get 'capexGb'
      y: model.get 'gb'
      color: color
      draggable: if isForecast then true else false
      segmentColor: if segmentColor then segmentColor else (if isForecast then @forecastColor else @currentColor)
      cursor: if isForecast then 'ns-resize' else 'default'
      marker:
        symbol: if isForecast then @forecastSymbol else @currentSymbol
        fillColor: color
        lineColor: color
        states:
          hover:
            fillColor: color


    getDataOnValue: (seriesModel, gbValue) ->
      seriesModel.set 'gb', gbValue
      @updateHigherModels seriesModel
      @getChartOptions().data