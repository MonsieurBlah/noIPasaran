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
			newId = app.dao.insertServer(req.body, true, (newId) ->
				res.redirect '/dns' + newId)

		@about = (req, res) ->
			res.render 'about', view: 'about', title: 'About'

		@admin = (req, res) ->
			isTemp = true
			isTemp = req.params.db == 'temp'
			app.dao.getServers(isTemp, (data) ->
				res.render 'admin', view: 'admin', title: 'Admin', servers: data, isTemp: isTemp)

		@valServer = (req, res) ->
			isTemp = req.params.db == 'temp'
			app.dao.valServer(req.params.id, (data) ->
				res.redirect '/admin/temp')

		@delServer = (req, res) ->
			isTemp = req.params.db == 'temp'
			app.dao.delServer(req.params.id, isTemp, (data) ->
				if isTemp
					res.redirect '/admin/temp'
				else
					res.redirect '/admin/final')



