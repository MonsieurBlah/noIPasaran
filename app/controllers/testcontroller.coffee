request = require 'request'
md5 = require 'MD5'
bcrypt = require 'bcrypt'
http = require 'http'

module.exports = (app) ->
	class app.testcontroller

		@test = (req, res) ->
			salt = bcrypt.genSaltSync 10
			hash = bcrypt.hashSync 'test', salt
			console.log hash
			console.log bcrypt.compareSync 'test', hash

		getHTML = (url, html) ->
			request.get url, (error, response, body) ->
				if not error and response.statusCode is 200
					html body

		getHTMLproxy = (url, html) ->
			urltoget = "http://noiproxy.herokuapp.com/html/#{url}"
			request.get urltoget, (error, response, body) ->
				if not error and response.statusCode is 200
					html md5 body
