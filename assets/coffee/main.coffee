define (require) ->
  $ = require 'jquery'
  require 'jquery_role'

  ChartView = require 'views/ChartView'
  ButtonsView = require 'views/ButtonsView'
  SeriesCollection = require 'models/SeriesCollection'

  collection = new SeriesCollection
  collection.reset window.data

  new ChartView {el: '@chart', collection: collection}
  new ButtonsView  {el: '@buttons'}