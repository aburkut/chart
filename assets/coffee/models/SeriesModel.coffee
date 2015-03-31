define (require) ->
  Model = require 'Model'


  class SeriesModel extends Model

    isForecast: ->
      @get('type') == @collection.typeForecast