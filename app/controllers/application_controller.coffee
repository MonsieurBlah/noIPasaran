db = require '../../lib/noipasaran/db'

module.exports = (app) ->
	class app.ApplicationController

		# GET /
		@index = (req, res) ->
			res.render 'index', view: 'index', title: 'Home'

		# GET & POST help
		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help'

		@helpPost = (req, res) ->
			newId = app.dao.insertServer(req.body, (newId) ->
				res.redirect '/dns/' + newId)

		@about = (req, res) ->
			res.render 'about', view: 'about', title: 'About'

		# TO CREATE !!
		@admin = (req, res) ->
			res.render 'admin', view: 'admin', title: 'Admin')

		@adminservers = (req, res) ->
			app.dao.getServers((data) ->
				res.render 'adminservers', view: 'adminservers', title: 'Servers', servers: data)

		@valServer = (req, res) ->
			app.dao.valServer(req.params.id, (data) ->
				res.redirect '/admin/temp')

		@delServer = (req, res) ->
			app.dao.delServer(req.params.id, (data) ->
				res.redirect '/admin/servers')
				



