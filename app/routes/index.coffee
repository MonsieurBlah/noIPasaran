express = require 'express'

module.exports = (app) ->

	auth = express.basicAuth('admin', 'test')
	# Index
	app.get '/', app.ApplicationController.index

	# Query
	app.post '/query', app.ApplicationController.query
	app.get '/url/:url', app.ApplicationController.url
	app.get '/ip/:ip', app.ApplicationController.ip

	# Help
	app.get '/help', app.ApplicationController.help
	app.post '/help', app.ApplicationController.helpPost

	# About
	app.get '/about', app.ApplicationController.about

	# Dns
	app.get '/dns/:id', app.ApplicationController.dns

	# Google
	app.get '/google/:query', app.ApplicationController.google

	# Admin DON'T FORGET TO RUN AUTH LATER !!!
	app.get '/admin/sites', app.ApplicationController.adminsites
	app.get '/admin/servers', app.ApplicationController.adminservers

	app.post '/admin/servers/validate/:id', app.ApplicationController.valServer
	app.post '/admin/servers/unvalidate/:id', app.ApplicationController.unvalServer
	app.post '/admin/servers/edit', app.ApplicationController.editServer
	app.post '/admin/servers/delete/:id', app.ApplicationController.delServer

	app.get '/admin/servers/modal/:id', app.ApplicationController.editServerModal

	app.post '/admin/sites/delete/:id', app.ApplicationController.delSite


	
	# Error handling (No previous route found. Assuming it’s a 404)
	app.get '/404/:something', app.ApplicationController.fourOfour

	app.get '/*', app.ApplicationController.fourOfour
