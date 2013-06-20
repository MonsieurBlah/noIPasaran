request = require 'request'
_ = require 'underscore'
http = require 'http'

module.exports = (app) ->
	class app.testcontroller

		@test = (req, res) ->
			console.log 'in test'
			res.send 'in test'

		