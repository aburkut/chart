express = require 'express'
path = require 'path'
app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use(express.static(__dirname + '/../public'));


app.use '/fonts', express.static(path.join(__dirname, '/public/fonts'))
app.use '/javascripts', express.static(path.join(__dirname, '/public/javascripts'))
app.use '/css', express.static(path.join(__dirname, '/public/css'))
app.use '/templates', express.static(path.join(__dirname, '/public/templates'));

#data =
#  month: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
#  gb: [19561845, 19879923, 20203174, 20531681, 20865529, 21204806, 21549600, 21900000, 22265730, 22637568, 23015615, 23399976]
#  capexGb: [0.013143054495133, 0.0130776661643114, 0.0130126031485686, 0.0129478638294215, 0.0128834465964393, 0.0128193498472033, 0.0127555719872669, 0.0126921114301164, 0.0126794193186862, 0.0126667398993676, 0.0126540731594682, 0.0126414190863087]
#  opexGb: [0.00171540274436659, 0.00170686840235482, 0.00169837651975604, 0.00168992688532939, 0.00168151928888497, 0.00167315352127857, 0.00166482937440654, 0.00165654664120054, 0.00165489009455934, 0.00165323520446478, 0.00165158196926032, 0.00164993038729105]


data = [
  {id: 1, month: 'January', gb: 19561845, capexGb: 0.013143054495133, opexGb: 0.00171540274436659}
  {id: 2, month: 'February', gb: 19879923, capexGb: 0.0130776661643114, opexGb: 0.00170686840235482}
  {id: 3, month: 'March', gb: 20203174, capexGb: 0.0130126031485686, opexGb: 0.00169837651975604}
  {id: 4, month: 'April', gb: 20531681, capexGb: 0.0129478638294215, opexGb: 0.00168992688532939}
  {id: 5, month: 'May', gb: 20865529, capexGb: 0.0128834465964393, opexGb: 0.00168151928888497}
  {id: 6, month: 'June', gb: 21204806, capexGb: 0.0128193498472033, opexGb: 0.00167315352127857}
  {id: 7, month: 'July', gb: 21549600, capexGb: 0.0127555719872669, opexGb: 0.00166482937440654}
  {id: 8, month: 'August', gb: 21900000, capexGb: 0.0126921114301164, opexGb: 0.00165654664120054}
  {id: 9, month: 'September', gb: 22265730, capexGb: 0.0126794193186862, opexGb: 0.00165489009455934}
  {id: 10, month: 'October', gb: 22637568, capexGb: 0.0126667398993676, opexGb: 0.00165323520446478}
  {id: 11, month: 'November', gb: 23015615, capexGb: 0.0126540731594682, opexGb: 0.00165158196926032}
  {id: 12, month: 'December', gb: 23399976, capexGb: 0.0126414190863087, opexGb: 0.00164993038729105}
]

app.all "/", (req, res) ->
  res.render 'index',
    title: 'Highcharts Advanced Usage'
    data: JSON.stringify data

server = app.listen process.env.PORT or 3000, ->
  console.log "Express server listening on port " + server.address().port