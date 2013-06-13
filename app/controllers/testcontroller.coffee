request = require 'request'
md5 = require 'MD5'
http = require 'http'

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


		getHash = (url, hash) ->
			request.get url, (error, response, body) ->
				if not error and response.statusCode is 200
					hash md5 body

		getHTMLproxy = (url, html) ->
			host = url.split "://"
			console.log host
			options = 
				host: 'noipasaran-proxy.eu01.aws.af.cm/'
				port: 8080
				path: url
				headers:
					Host: host[1]
			console.log "here"
			http.get options, (req, res) ->
				console.log res
				html res