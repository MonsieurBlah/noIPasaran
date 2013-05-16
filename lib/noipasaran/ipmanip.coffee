request = require 'request'
dns = require 'native-dns'
util = require 'util'


module.exports = (app) ->
	class app.ipmanip

		@getClientIP = (req, ip) ->
			ipAddress = null
			forwardedIpsStr = req.header 'x-forwarded-for'
			if forwardedIpsStr
				forwardedIps = forwardedIpsStr.split ','
				ipAddress = forwardedIps[0]
			if !ipAddress
				ipAddress = req.connection.remoteAddress
			ip ipAddress

		@isIp = (str, match) ->
			matchres = /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/.test(str)
			match matchres

		@getIpCountry = (ip, country) ->
			url = 'http://freegeoip.net/json/' + ip
			request.get url, (error, response, body) ->
				if !error && response.statusCode == 200
					data = JSON.parse body
					country data.country_name

		@resolveServers = (url, servers, resolved) ->
			result = []
			treatServer(url, server, (serverObject) ->
				resolved result if result.push serverObject is servers.length
			) for server in servers

		treatServer = (url, server, serverObject) ->
			oneServer = new Object()
			oneServer.name = server.name
			oneServer.primary_ip = server.primary_ip
			oneServer.secondary_ip = server.secondary_ip
			resolve url, server.primary_ip, (answer1) ->
				oneServer.primary_resolve = answer1
				resolve url, server.secondary_ip, (answer2) ->
					oneServer.secondary_resolve = answer2
					serverObject oneServer

		insertInTable = (addresses, ip) ->
			if addresses.indexOf ip > -1
				console.log ip + ' already exists'
			else
				addresses.push ip

		resolve = (url, server, ips) ->
			question = dns.Question({
				name: url,
				type: 'A'})
			start = Date.now()
			req = dns.Request({
				question: question,
				server: {address: server}
				})
			req.on('timeout', () ->
				console.log 'Timeout')
			req.on('message', (err, answer) ->
				console.log 'boucle'
				addresses = []
				addresses.push(a.address) for a in answer.answer
				ips(addresses)
			)
			req.on('end', () ->
				delta = Date.now() - start
				console.log 'Finished processing request: ' + delta.toString() + 'ms'
			)
			req.send()
