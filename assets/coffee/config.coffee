requirejs.config
  baseUrl: '/javascripts'
  deps: ['main']

  waitSeconds: 30

  paths:
  # Libraries
    jquery: 'lib/jquery/dist/jquery'
    _: 'lib/underscore/underscore'
    Backbone: 'lib/backbone/backbone'
    Highcharts: 'lib/highcharts/highcharts'
    Highcharts_draggable_points: 'lib/highcharts/draggable-points'
    Highchart_multicolor_series: 'lib/highcharts/multicolor_series'
    Handlebars: 'lib/handlebars/handlebars'

  # Requirejs's plugins
    text: 'lib/requirejs/text'
    hbars: 'lib/requirejs/hbars'
    json: 'lib/requirejs/json'

  # Object helpers
    utils: 'helpers/utils'

  # jQuery's plugins
    jquery_role: 'lib/jquery/jquery.role'

  # Templates path
    templates: '../templates'

    components: './components'
    models: './models'
    views: './views'

    utils: 'helpers/utils'


  hbars:
    extension: '.hbs'


  map:
  # Aliases
    '*':
      underscore: '_'
      backbone: 'Backbone'
      jQuery: 'jquery'
      $: 'jquery'
      Collection: 'core/collection'
      View: 'core/view'
      Model: 'core/model'
      Router: 'core/router'


# Not AMD modules
  shim:
    _:
      exports: '_'

    Backbone:
      deps: ['jquery', '_']
      exports: 'Backbone'

    Highcharts:
      deps: ['jquery']
      exports: 'Highcharts'

    Handlebars:
      exports: 'Handlebars'

    jquery_role: ['jquery']

    Highcharts_draggable_points: ['Highcharts']

    Highchart_multicolor_series: ['Highcharts']


  onBuildWrite: (moduleName, path, content) ->
    if moduleName == 'Handlebars'
      path = path.replace 'handlebars.js', 'handlebars.runtime.js'
      content = fs.readFileSync(path).toString()
      content = content.replace /(define\()(function)/, '$1"handlebars", $2'

    content