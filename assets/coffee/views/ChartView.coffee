define (require) ->
  View = require 'View'
  Highcharts = require 'Highcharts'
  TooltipView = require 'views/TooltipView'
  require 'Highcharts_draggable_points'
  require 'Highchart_multicolor_series'
  _ = require '_'


  class ChartView extends View

    listen:
      'sub click:restore': 'restoreDefault'

    redraw: ->
      @chartOptions = @collection.getChartOptions()
      @chart.redraw()


    restoreDefault: ->
      chartOptions = @collection.getDefaultChartOptions()
      @chart.yAxis[0].update max: @defaultYMax
      @chart.series[0].setData chartOptions.data, true
      @updateCursorForPoints()


    updateCursorForPoints: ->
      _.each @chart.series[0].data, (point) ->
        if point.graphic
          point.graphic.attr
            cursor: point.options.cursor


    render: ->
      series = []
      that = @

      chartOptions = @collection.getChartOptions()

      @chart = new Highcharts.Chart
        chart:
          renderTo: @el
          animation: false
          type: 'coloredline'

        title:
          text: null

        credits:
          enabled: false

        legend:
          enabled: false

        plotOptions:
          series:
            point:
              events:
                drag: that.onDrag
                drop: that.onDrop

        xAxis:
          categories: chartOptions.categories
          plotLines: [
            color: '#60baea'
            dashStyle: 'Solid'
            value: chartOptions.data.length / 2 - 1
            width: 1
            min: 0
          ]

          gridLineWidth: 1
          gridLineDashStyle: 'ShortDot'
          lineColor: '#60baea'
          lineWidth: 3

        yAxis:
          endOnTick: true
          title:
            enabled: false

        tooltip:
          useHtml: true
          formatter: ->
            that.renderTooltip this

        series: [
          data: chartOptions.data
          draggableY: true
          dragMinY: 0
        ]

      @defaultYMax = @chart.yAxis[0].max
      @updateCursorForPoints()


    renderTooltip: (point) ->
      view = new TooltipView
        point: point

      view.renderTemplate()


    onDrag: (e, redraw = false) =>
      dragPoint = e.currentTarget
      data = @collection.getDataOnValue(@collection.get(dragPoint.id), dragPoint.y)
      @chart.series[0].setData data, redraw


    onDrop: (e) =>
      @onDrag e, true
      @updateCursorForPoints()
      maxPoint = _.max @chart.series[0].data, (series) -> series.y
      maxValue = maxPoint.y
      if maxValue > @defaultYMax
        newMax = maxValue * 1.05
        @chart.yAxis[0].update max: newMax
      else
        @chart.yAxis[0].update max: @defaultYMax