gulp = require 'gulp'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
nodemon = require 'gulp-nodemon'
browserify = require 'gulp-browserify'
clean = require 'gulp-clean'
util = require 'gulp-util'
sequnce = require 'run-sequence'
ngmin = require 'gulp-ngmin'
watch = require 'gulp-watch'
concat = require 'gulp-concat'
es = require 'event-stream'
changed = require 'gulp-changed'


paths =
  bower: 'assets/bower_components'
  lib: 'assets/lib'
  stylesLib: [
    'assets/bower_components/bootstrap/dist/css/bootstrap.min.css'
  ]
  static: 'public'
  templates: 'assets/templates'
  fonts: 'assets/bower_components/bootstrap/dist/fonts'
  styles: 'assets/styles'
  core: 'assets/core'
  coffee: 'assets/coffee'


gulp.task 'coffee', ->
  gulp.src "#{paths.coffee}/**/**.coffee"
  .pipe watch "#{paths.coffee}/**/**"
  .pipe changed "#{paths.static}/javascripts"
  .pipe sourcemaps.init()
  .pipe coffee(bare: true).on 'error', util.log
  .pipe sourcemaps.write()
  .pipe gulp.dest "#{paths.static}/javascripts"


gulp.task 'styles', ->
  stylesLib = gulp.src paths.stylesLib
  styles = gulp.src "#{paths.styles}/**/**"

  pipe = es.concat stylesLib , styles
    .pipe concat 'compiled.css'
    .pipe gulp.dest "#{paths.static}/css/"


gulp.task 'copy', ->
  gulp.src("#{paths.fonts}/**/**").pipe gulp.dest "#{paths.static}/fonts"
  gulp.src("#{paths.templates}/**/**").pipe gulp.dest "#{paths.static}/templates"
  gulp.src("#{paths.bower}/**/**").pipe gulp.dest "#{paths.static}/javascripts/lib"
  gulp.src("#{paths.core}/**/**").pipe gulp.dest "#{paths.static}/javascripts/core"
  gulp.src("#{paths.lib}/**/**").pipe gulp.dest "#{paths.static}/javascripts/lib"




gulp.task 'clean', ->
  gulp.src(paths.static).pipe clean()


gulp.task 'server', ->
  nodemon
    script: 'index.coffee'
    ext: 'html js coffee'
    ignore: ['/assets/**/**', "/#{paths.static}/**/**"]
  .on 'restart', ->
    console.log 'SERVER RESTARTED'


gulp.task 'build', ->
  sequnce 'clean', [
    'copy', 'coffee', 'styles', 'server'
  ]


gulp.task 'default', ['build']