db = require '../../lib/noipasaran/db'

module.exports = (app) ->
	class app.ApplicationController

		# GET /
		@index = (req, res) ->
			res.render 'index', view: 'index', title: 'Home'

		# GET & POST help
		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help'

		@help_post = (req, res) ->
			console.log req.body
			newId = db.insert_server(req.body, true, (newId) ->
				console.log 'id= ' + newId
				res.redirect '/dns' + newId)

		@admin = (req, res) ->
			isTemp = true
			isTemp = req.params.db == 'temp'
			db.get_servers(isTemp, (data) ->
				console.log data
				res.render 'admin', view: 'admin', title: 'Admin', servers: data, isTemp: isTemp)



