request = require 'request'
_ = require 'underscore'
http = require 'http'

module.exports = (app) ->
	class app.testcontroller

		@test = (req, res) ->
			url = 'http://wikileaks.org'
			app.dao.getSiteByUrl url, (site) ->
				console.log site
				site.ip.sort()
				console.log site

		