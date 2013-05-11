request = require 'request'

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
					console.log 'Is an ip'
				else
					console.log 'Not an ip'
					# Resolve the url
					app.ipmanip.resolve(queryStr, '8.8.8.8', (resip) ->
						# Insert the url into the db with his IP
						app.dao.insertSite(queryStr, resip, (id) ->
							console.log 'Site ' + id + ' inserted'
						)
						# Get the client IP
						app.ipmanip.getClientIP(req, (ip) ->
							# To remove before prod
							ip = '81.247.34.211'
							# ip = '8.8.8.8'
							# Get the client IP informations
							app.ipmanip.getIpInfos(ip, (data) ->
								country = data.country_name
								# Get the servers from the client country
								app.dao.getServersWhereLocation(country, (servers) ->
									res.render 'resulturl', view: 'resulturl', title: 'Result', url: queryStr, urlip: resip, clientip: ip, country: country, servers: servers
								)
							)
						)
					)
			)

		# HELP
		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help'

		@helpPost = (req, res) ->
			app.dao.insertServer(req.body, (newId) ->
				res.end(JSON.stringify(newId))
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
				res.end(JSON.stringify(data))
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


