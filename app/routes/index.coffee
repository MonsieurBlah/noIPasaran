express = require 'express'
bcrypt = require 'bcrypt'

module.exports = (app) ->

	auth = express.basicAuth (user, pass) ->
		user is 'admin' and bcrypt.compareSync pass, '$2a$10$f3YwK9fjEcSQs4W143.O1el7vQpkb95jtEOL7Zim1bISK5L01ztCK'
	# Index
	app.get '/', app.maincontroller.index

	# Query
	app.post '/query', app.maincontroller.query
	app.get '/url/:url', app.maincontroller.url
	app.get '/url/:url/isp/:isp', app.maincontroller.isp
	app.get '/url/:url/country/:country', app.maincontroller.country
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

	# Admin
	app.get '/admin/sites', auth,auth, app.admincontroller.adminsites
	app.get '/admin/servers', auth,app.admincontroller.adminservers

	app.post '/admin/servers/toggle/:id', auth,app.admincontroller.toggleServer
	app.post '/admin/servers/edit', auth,app.admincontroller.editServer
	app.post '/admin/servers/delete/:id', auth,app.admincontroller.delServer

	app.get '/admin/servers/modal/:id', auth, app.admincontroller.editServerModal

	app.post '/admin/sites/delete/:id', auth, app.admincontroller.delSite
	app.post '/admin/sites/clean', auth, app.admincontroller.cleanSites

	app.get '/test', auth, app.testcontroller.test


	
	# Error handling (No previous route found. Assuming it’s a 404)
	app.get '/404/:something', app.maincontroller.fourOfour

	app.get '/*', app.maincontroller.fourOfour
