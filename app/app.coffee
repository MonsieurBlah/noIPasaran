# Modules
express = require 'express'
http = require 'http'
app = express()

# Boot setup
require("#{__dirname}/../config/boot")(app)

# Configuration
app.configure ->
  port = process.env.PORT || 3000
  if process.argv.indexOf('-p') >= 0
    port = process.argv[process.argv.indexOf('-p') + 1]
  # set the port
  app.set 'port', port
  # set the views dir
  app.set 'views', "#{__dirname}/views"
  # set Jade as view engine
  app.set 'view engine', 'jade'
  # specify that the outputed HTML is not minified
  app.locals.pretty = true
  # set the public directory
  app.use express.static("#{__dirname}/../public")
  # use express default favicon [TODO change favicon]
  app.use express.favicon()
  # set the logger to full stack view
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  # add connect-asset middleware
  app.use require('connect-assets')(src: "#{__dirname}/assets")
  app.use app.router
  # add the routine check
  app.use app.check.routine()
  # Load the globals servers from the DB in RAM
  app.use app.dao.loadGlobalServers()
  # Start the global servers for the auto-refresh of the DB in the RAM
  app.use app.dao.refreshGlobalServers()


app.configure 'development', ->
  app.use express.errorHandler()

# Routes
require("#{__dirname}/routes")(app)

# Server
http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'} in #{app.settings.env} mode"
