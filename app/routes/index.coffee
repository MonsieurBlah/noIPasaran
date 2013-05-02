express = require 'express'

module.exports = (app) ->

  auth = express.basicAuth('admin', 'test')
  # Index
  app.get '/', app.ApplicationController.index

  # Help
  app.get '/help', app.ApplicationController.help
  app.post '/help', app.ApplicationController.help_post

  app.get '/admin', app.ApplicationController.admin
  app.get '/admin/:db', app.ApplicationController.admin

  # Error handling (No previous route found. Assuming it’s a 404)
  app.get '/*', (req, res) ->
    NotFound res

  NotFound = (res) ->
    res.render '404', status: 404, view: 'four-o-four', title: 'four-o-four'
