db = require '../../lib/noipasaran/db'

module.exports = (app) ->
	class app.ApplicationController

		# GET /
		@index = (req, res) ->
			res.render 'index', view: 'index', title: 'Home'

		@help = (req, res) ->
			res.render 'help', view: 'help', title: 'Help'

		@help_post = (req, res) ->
			console.log req.body
			id = 0
			db.insert_dns_temp(req.body, id)
			res.redirect '/dns' + id