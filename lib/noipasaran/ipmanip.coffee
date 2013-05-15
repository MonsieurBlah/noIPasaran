request = require 'request'
# dns = require 'native-dns'
util = require 'util'


module.exports = (app) ->
	class app.ipmanip

		@getClientIP = (req, ip) ->
			ipAddress = null
			forwardedIpsStr = req.header('x-forwarded-for')
			if forwardedIpsStr
				forwardedIps = forwardedIpsStr.split(',')
				ipAddress = forwardedIps[0]
			if !ipAddress
				ipAddress = req.connection.remoteAddress
			ip(ipAddress)

		@isIp = (str, match) ->
			matchres = /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/.test(str)
			match(matchres)

		@getIpCountry = (ip, country) ->
			url = 'http://freegeoip.net/json/' + ip
			request.get(url, (error, response, body) ->
				if !error && response.statusCode == 200
					data = JSON.parse(body)
					console.log 'DATA'
					console.log data
					country(data.country_name)
			)

		@getProbableIP = (url, servers, ip) ->
			alladdresses = []
			resolve(url, server, (ips) ->
				alladdresses.push(ips)
			) for server in servers
			console.log alladdresses
			ip(alladdresses[0])


		@resolve = (url, server, ips) ->
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
				results 
				console.log 'boucle'
				addresses = []
				addresses.push(a.address) for a in answer.answer
				ip(addresses)
			)
			req.on('end', () ->
				delta = Date.now() - start
				console.log 'Finished processing request: ' + delta.toString() + 'ms'
			)
			req.send()
