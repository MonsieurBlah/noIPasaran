request = require 'request'
dns = require 'dns'
# dns = require 'native-dns'
# util = require 'util'


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

		@getIpInfos = (ip, data) ->
			url = 'http://freegeoip.net/json/' + ip
			request.get(url, (error, response, body) ->
				if !error && response.statusCode == 200
					data(JSON.parse(body))
			)

		@resolve = (url, server, ip) ->
			dns.resolve4(url, (err, address) ->
				if err 
					throw err
				console.log address
				ip(address[0])
			)
			# question = dns.Question({
			# 	name: url,
			# 	type: 'A'})
			# start = Data.now()
			# req = dns.Request({
			# 	question: question,
			# 	server: {address: server}
			# 	})
			# req.on('timeout', () ->
			# 	console.log 'Timeout')
			# req.on('message', (err, answer) ->
			# 	console.log answer
			# 	answer.answer.forEach(a) ->
			# 		console.log a.address
			# )
			# req.on('end', () ->
			# 	delta = Date.now() - start
			# 	console.log 'Finished processing request: ' + delta.toString() + 'ms'
			# )
			# req.send()