request = require 'request'

module.exports = (app) ->
	class app.ApplicationController

	# NAVBAR CONTENT
		# INDEX
		@index = (req, res) ->
			res.render 'index', view: 'index', title: 'Home'

		@query = (req, res) ->
			queryStr = req.body.query
			app.ipmanip.isIp(queryStr, (isIp) ->
				if isIp
					console.log 'Is an ip'
				else
					console.log 'Not an ip'
				app.ipmanip.getClientIP(req, (ip) ->
					url = 'http://freegeoip.net/json/' + ip
					console.log 'URL: ' + url
					request.get(url, (error, response, body) ->
						if error 
							console.log error
						console.log body
						res.render 'resulturl', view: 'resulturl', title: 'Result', url: queryStr, clientip: ip, country: body.country_name
					)
				)
			)

			# app.ipmanip.getClientIP(req, (ip) ->
			# 	app.get('http://freegeoip.net/json/' + ip, (fulldata) ->
			# 		console.log 'FULL DATA'
			# 		console.log fulldata
			# 	)

		# HELP
		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help'

		@helpPost = (req, res) ->
			newId = app.dao.insertServer(req.body, (newId) ->
				res.redirect '/dns/' + newId)

		# ABOUT
		@about = (req, res) ->
			res.render 'about', view: 'about', title: 'About'

		#ADMIN
		@admin = (req, res) ->
			res.render 'admin', view: 'admin', title: 'Admin'
		# Admin servers
		@adminservers = (req, res) ->
			app.dao.getServers((data) ->
				res.render 'adminservers', view: 'adminservers', title: 'Servers', servers: data)

		@valServer = (req, res) ->
			app.dao.valServer(req.params.id, (data) ->
				res.redirect '/admin/temp')

		@delServer = (req, res) ->
			app.dao.delServer(req.params.id, (data) ->
				res.redirect '/admin/servers')

		# Admin sites	
		@adminsites = (req, res) ->
			app.dao.getSites((data) ->
				res.render 'adminsites', view: 'adminsites', title: 'Sites', sites: data)


