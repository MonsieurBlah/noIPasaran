request = require 'request'
dns = require 'native-dns'
async = require 'async'
_ = require 'underscore'

module.exports = (app) ->
	class app.ipmanip

		@getIpAndData = (req, url, data) ->
			result = new Object()
			app.dao.getSiteByUrl url, (site) ->
				console.log data
				console.log url
				if data.length > 0
					result.site = site
				else
					getIpAndInsert url, (site) ->
						result.site = site
				getClientIP req, (clientip) ->
					result.clientip = clientip
					getIpCountry clientip, (country) ->
						result.country = country
						app.dao.getLocalServers country, (localServers) ->
							resolveLocalServers url, localServers, (localAnswers) ->
								result.local = localAnswers
								data result

		getIpAndInsert = (url, data) ->
			app.dao.getGlobalServers (globalServers) ->
				resolveGlobalServers url, globalServers, (answer) ->
					app.dao.insertAndGetSite url, answer, (site) ->
						data site

		getClientIP = (req, ip) ->
			ipAddress = null
			forwardedIpsStr = req.header 'x-forwarded-for'
			if forwardedIpsStr
				forwardedIps = forwardedIpsStr.split ','
				ipAddress = forwardedIps[0]
			if !ipAddress
				ipAddress = req.connection.remoteAddress
			ipAddress = '81.247.34.211'
			ip ipAddress

		@isIp = (str, match) ->
			matchres = /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/.test(str)
			match matchres

		getIpCountry = (ip, country) ->
			url = 'http://freegeoip.net/json/' + ip
			request.get url, (error, response, body) ->
				if !error && response.statusCode == 200
					data = JSON.parse body
					country data.country_name

		resolveGlobalServers = (url, servers, data) ->
			result = []
			count = 0
			treatGlobalServer(url, server, (resolved) ->
				result = _.union(resolved, result)
				count++
				data result if count is servers.length
			) for server in servers

		resolveLocalServers = (url, servers, resolved) ->
			result = []
			treatLocalServer(url, server, (serverObject) ->
				result.push serverObject
				resolved result if result.length is servers.length
			) for server in servers

		treatGlobalServer = (url, server, answers) ->
			result = []
			async.parallel [
				(callback) ->
					resolve url, server.primary_ip, (answer1) ->
						if answer1.addresses
							result = _.union(result, answer1.addresses)
						callback()
				,(callback) ->
					resolve url, server.secondary_ip, (answer2) ->
						if answer2.addresses
							result = _.union(result, answer2.addresses)
						callback()
				], (err) ->
					if err 
						throw err
					answers result

		treatLocalServer = (url, server, serverObject) ->
			oneServer = new Object()
			oneServer.name = server.name
			oneServer.primary_ip = server.primary_ip
			oneServer.secondary_ip = server.secondary_ip
			resolve url, server.primary_ip, (answer1) ->
				oneServer.primary_result = answer1
				resolve url, server.secondary_ip, (answer2) ->
					oneServer.secondary_result = answer2
					serverObject oneServer

		insertInTable = (addresses, ip) ->
			if addresses.indexOf ip > -1
				console.log ip + ' already exists'
			else
				addresses.push ip

		resolve = (url, server, data) ->
			question = dns.Question({
				name: url,
				type: 'A'})
			response = new Object()
			start = Date.now()
			req = dns.Request({
				question: question,
				server: {address: server},
				timeout: 3000
				})
			req.on('timeout', () ->
				response.timeout = true
			)
			req.on('message', (err, answer) ->
				addresses = []
				addresses.push(a.address) for a in answer.answer
				response.addresses = addresses
			)
			req.on('end', () ->
				delta = Date.now() - start
				response.time = delta.toString()
				data response
			)
			req.send()

		getIPInfos = (ip, infos) ->
			result = new Object()
			url = 'http://freegeoip.net/json/' + ip
			request.get url, (error, response, body) ->
				if !error && response.statusCode == 200
					data = JSON.parse body
					result.latitude = data.latitude
					result.longitude = data.longitude
					result.country = data.region_name + ' ' + data.country_name
					result.city = data.city
					infos result

		# TO REWRITE WITH COFFEE STRING CONCAT
		base_url = 'http://maps.googleapis.com/maps/api/staticmap?'
		size = 'size=640x400'
		scale = 'scale=1'
		key = 'key=AIzaSyDkzxNkiE6XtBgM_FxME9zhaZZn1NJHQUlI'
		marker = 'markers='
		marker_separator = '%7C'
		color_red = 'color:red'
		path_base = 'path=color:0x0000ff|weight:5|'
		sensor = 'sensor=false'
		separator = '&'

		@getStaticMapsUrl = (req, ip, data) ->
			getClientIP req, (clientIp) ->
				clientIp = '81.247.98.175'
				getIPInfos clientIp, (clientInfos) ->
					getIPInfos ip, (serverInfos) ->
						client = clientInfos.latitude + ',' + clientInfos.longitude
						server = serverInfos.latitude + ',' + serverInfos.longitude
						fullUrl = base_url + scale + separator + size + separator + marker + color_red
						fullUrl = fullUrl + marker_separator + client
						fullUrl = fullUrl + separator + marker + color_red + marker_separator
						fullUrl = fullUrl + server + separator
						fullUrl = fullUrl + path_base + client + '|' + server + separator + sensor
						result = new Object()
						result.url = fullUrl
						result.client = clientInfos
						result.server = serverInfos
						data result

