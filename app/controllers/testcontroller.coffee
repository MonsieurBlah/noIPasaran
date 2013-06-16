request = require 'request'
md5 = require 'MD5'
http = require 'http'

module.exports = (app) ->
	class app.testcontroller

		@test = (req, res) ->
			url = 'thepiratebay.se'
			url1 = '194.71.107.15'
			getHTMLproxy url, (html) ->
				console.log url + ' ' + md5(html)
				getHTMLproxy url1, (html) ->
					console.log html
					console.log url1 + ' ' + md5(html)

		getHTML = (url, html) ->
			request.get url, (error, response, body) ->
				if not error and response.statusCode is 200
					html body

		getHTMLproxy = (url, html) ->
			urltoget = "http://noiproxy.herokuapp.com/html/#{url}"
			request.get urltoget, (error, response, body) ->
				if not error and response.statusCode is 200
					html md5 body
