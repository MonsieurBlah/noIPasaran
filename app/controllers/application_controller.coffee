request = require 'request'
marked = require 'marked'

module.exports = (app) ->
	class app.ApplicationController

	# NAVBAR CONTENT
		# INDEX
		@index = (req, res) ->
			res.render 'index', view: 'index', title: 'Home'

		@query = (req, res) ->
			queryStr = req.body.query
			console.log 'QUERY:' + queryStr
			# Check if the query is an IP or an URL
			app.ipmanip.isIp(queryStr, (isIp) ->
				if isIp
					res.redirect '/ip/' + queryStr
				else
					res.redirect '/url/' + queryStr
			)

		@url = (req, res) ->
			console.log 'Not an ip'
			url = req.params.url
			app.ipmanip.getClientIP(req, (ip) ->
				ip = '81.247.34.211'
				app.ipmanip.getIpCountry(ip, (country) ->
					console.log 'country: ' + country
					app.dao.getServersWhereLocation(country, (serversres) ->
						console.log serversres
						servers = []
						servers.push(server.primary_ip) for server in serversres
						servers.push(server.secondary_ip) for server in serversres
						console.log servers
						app.ipmanip.getProbableIP(url, servers, (resip) ->
							if resip != '0.0.0.0'
								# Insert the url into the db with his IP
								app.dao.insertSite(url, resip, (id) ->
									console.log 'Site ' + id + ' inserted'
								)
							else
								res.redirect '/google/' + url
							res.render 'url', view: 'url', title: 'Result', url: url, urlip: resip, clientip: ip, country: country, servers: servers
						)
					)
				)
			)

		@ip = (req, res) ->
			console.log 'Is an ip'
			res.render 'ip', view 'ip'

		# HELP
		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help'

		@helpPost = (req, res) ->
			app.dao.insertServer(req.body, (newId) ->
				res.json(newId)
			)

		# ABOUT
		@about = (req, res) ->
			res.render 'about', view: 'about', title: 'About'

		# DNS
		@dns = (req, res) ->
			app.dao.getServer(req.params.id, (data) ->
				console.log data
				res.render 'dns', view: 'dns', title: data[0].name, server: data[0]
			)

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

		@editServer = (req, res) ->
			app.dao.editServer(req.body, (data) ->
				res.json(data)
			)

		@delServer = (req, res) ->
			app.dao.delServer(req.params.id, (data) ->
				res.redirect '/admin/servers')

		@editServerModal = (req, res) ->
			app.dao.getServer(req.params.id, (data) ->
				res.render 'editservermodal', view: 'editservermodal', server: data[0]
			)

		# Admin sites	
		@adminsites = (req, res) ->
			app.dao.getSites((data) ->
				res.render 'adminsites', view: 'adminsites', title: 'Sites', sites: data)

		@google = (req, res) ->
			res.render 'google', view: 'google', title: '!Google', query: req.params.query


