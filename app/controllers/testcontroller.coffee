request = require 'request'
md5 = require 'MD5'

module.exports = (app) ->
	class app.testcontroller

		@test = (req, res) ->
			url = 'http://www.thepiratebay.se'
			getHTML url, (html) ->
				console.log md5(html)
			res.render 'test', view: 'test', title: 'Test'

		getHTML = (url, html) ->
			request.get url, (error, response, body) ->
				if not error and response.statusCode is 200
					html body