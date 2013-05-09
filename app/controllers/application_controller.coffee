module.exports = (app) ->
	class app.ApplicationController

	# NAVBAR CONTENT
		# INDEX
		@index = (req, res) ->
			console.log 'REQ UNDER'
			app.ipmanip.getClientIP(req, (ip) ->
				console.log ip)
			res.render 'index', view: 'index', title: 'Home'

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


