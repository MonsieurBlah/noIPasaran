express = require 'express'

module.exports = (app) ->

	auth = express.basicAuth('admin', 'test')
	# Index
	app.get '/', app.ApplicationController.index

	# Help
	app.get '/help', app.ApplicationController.help
	app.post '/help', app.ApplicationController.helpPost

	# About
	app.get '/about', app.ApplicationController.about

	# Admin DON'T FORGET TO RUN AUTH LATER !!!
	app.get '/admin', app.ApplicationController.admin
	app.get '/admin/sites', app.ApplicationController.adminsites
	app.get '/admin/servers', app.ApplicationController.adminservers

	app.post '/admin/servers/validate/:id', app.ApplicationController.valServer
	# app.post '/admin/:db/edit/:id', app.ApplicationController.editServer
	app.post '/admin/servers/delete/:id', app.ApplicationController.delServer



	# Error handling (No previous route found. Assuming it’s a 404)
	app.get '/*', (req, res) ->
		NotFound res

	NotFound = (res) ->
		res.render '404', status: 404, view: 'four-o-four', title: 'four-o-four'
