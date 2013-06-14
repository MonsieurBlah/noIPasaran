express = require 'express'

module.exports = (app) ->

	auth = express.basicAuth('admin', 'test')
	# Index
	app.get '/', app.maincontroller.index

	# Query
	app.post '/query', app.maincontroller.query
	app.get '/url/:url', app.maincontroller.url
	app.get '/ip/:ip', app.maincontroller.ip

	# Help
	app.get '/help', app.maincontroller.help
	app.post '/help', app.maincontroller.helpPost

	# About
	app.get '/about', app.maincontroller.about

	# Dns
	app.get '/dns/:id', app.maincontroller.dns

	# Google
	app.get '/google/:query', app.maincontroller.google

	# Admin DON'T FORGET TO RUN AUTH LATER !!!
	app.get '/admin/sites', app.admincontroller.adminsites
	app.get '/admin/servers', app.admincontroller.adminservers

	app.post '/admin/servers/toggle/:id', app.admincontroller.toggleServer
	app.post '/admin/servers/edit', app.admincontroller.editServer
	app.post '/admin/servers/delete/:id', app.admincontroller.delServer

	app.get '/admin/servers/modal/:id', app.admincontroller.editServerModal

	app.post '/admin/sites/delete/:id', app.admincontroller.delSite
	app.post '/admin/sites/clean', app.admincontroller.cleanSites

	app.get '/test', app.testcontroller.test


	
	# Error handling (No previous route found. Assuming it’s a 404)
	app.get '/404/:something', app.maincontroller.fourOfour

	app.get '/*', app.maincontroller.fourOfour
