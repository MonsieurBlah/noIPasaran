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
			# Check if the query is an IP or an URL
			app.ipmanip.isIp queryStr, (isIp) ->
				if isIp
					res.redirect "/ip/#{queryStr}"
				else
					# Check if there is a . means it could be a URL
					dot = queryStr.split('.').length - 1
					if dot
						res.redirect "/url/#{queryStr}"
					else
						res.redirect "/404/#{queryStr}"

		@url = (req, res) ->
			# Get the url
			url = req.params.url
			# If no www. and only one . in the url
			if url.indexOf 'www.', 0 < 0 and url.split('.').length - 1 < 2
				# Add www. in front of the url
				url = "www.#{url}"
			app.ipmanip.getIpAndData req, url, (data) ->
				console.log data
				###app.dao.insertSite url, resip, (id) ->
					console.log 'Site ' + id + ' inserted'###
				res.render 'url', view: 'url', title: "#{url}", url: url, clientip: data.clientip, country: data.country, resultlocal: data.local, resultglobal: data.global 

		@ip = (req, res) ->
			# Get the ip
			ip = req.params.ip
			# Get the server from the db
			app.dao.getServerByIp ip, (server) ->
				# if there is a server with this ip
				if server.length > 0
					# Build the static Maps URL
					app.ipmanip.getStaticMapsUrl req, server[0].primary_ip, (data) ->
						# Get the distance between client and server
						app.distance.get data.server.latitude, data.server.longitude, data.client.latitude, data.client.longitude, (distance) ->
							res.render 'ip', view: 'ip', title: ip, url: data.url, server: server[0], serverInfo: data.server, distance: distance
				# else redirect to 404 // EXAMINE THE POSSIBILITY TO RED TO HELP
				else
					res.redirect "/404/#{ip}"

		# HELP
		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help me'

		@helpPost = (req, res) ->
			app.dao.insertServer req.body, (newId) ->
				res.json newId

		# ABOUT
		@about = (req, res) ->
			res.render 'about', view: 'about', title: 'About'

		# DNS
		@dns = (req, res) ->
			app.dao.getServer req.params.id, (data) ->
				res.render 'dns', view: 'dns', title: data[0].name, server: data[0]

		#ADMIN
		# Admin servers
		@adminservers = (req, res) ->
			app.dao.getServers (data) ->
				res.render 'adminservers', view: 'adminservers', title: 'Servers', servers: data

		@valServer = (req, res) ->
			app.dao.valServer req.params.id, (data) ->
				res.end JSON.stringify data

		@unvalServer = (req, res) ->
			app.dao.unvalServer req.params.id, (data) ->
				res.json data

		@editServer = (req, res) ->
			app.dao.editServer req.body, (data) ->
				res.json data

		@delServer = (req, res) ->
			app.dao.delServer req.params.id, (data) ->
				res.json data

		@editServerModal = (req, res) ->
			app.dao.getServer req.params.id, (data) ->
				res.render 'editservermodal', view: 'editservermodal', server: data[0]

		# Admin sites	
		@adminsites = (req, res) ->
			app.dao.getSites (data) ->
				res.render 'adminsites', view: 'adminsites', title: 'Sites', sites: data

		@delSite = (req, res) ->
			app.dao.delSite req.params.id, (data) ->
				console.log data
				res.json data

		@google = (req, res) ->
			res.render 'google', view: 'google', title: '!Google', query: req.params.query

		@fourOfour = (req, res) ->
			something = req.params.something
			if something
				res.render '404', status: 404, view: 'four-o-four', title: '404.404.404.404', something: something
			else
				res.render '404', status: 404, view: 'four-o-four', title: '404.404.404.404', something: null




