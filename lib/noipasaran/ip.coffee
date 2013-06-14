request = require 'request'
dns = require 'dns'
async = require 'async'
_ = require 'underscore'
dns_ = require 'native-dns'
md5 = require 'MD5'

module.exports = (app) ->
	class app.ip

		@getIpAndData = (req, url, data) ->
			result = new Object()
			async.parallel [
				(callback) ->
					getSite url, (site) ->
						site.ip = site.ip.split ','
						result.site = site
						callback()
				,(callback) ->
					getClientIP req, (clientIP) ->
						result.clientip = clientIP
						async.parallel [
							(callback) ->
								getIpCountry clientIP, (country) ->
									result.country = country
									callback()
							,(callback) ->
								getIpISP clientIP, (isp) ->
									result.isp = isp
									callback()
						], (err) ->
							throw err if err
							app.dao.getServerByName result.isp, (ispServers) ->
								if not ispServers
									app.dao.getLocalServer result.country, (countryServers) ->
										result.servers = countryServers
										callback()
								else
									result.servers = ispServers
									callback()
			], (err) ->
				throw err if err
				resolveLocalServers url, result.servers, (localAnswers) ->
					fixed = off
					checkIfAnswerIsValid(result.site.ip, answer, (valid) ->
						answer.valid = valid
						app.dao.fixSite(result.site.site_id, (done) ->
							fixed is on if done
						) if valid is 'fail' and not fixed
					) for answer in localAnswers
					result.local = localAnswers
					data result


		getSite = (url, site) ->
			app.dao.getSiteByUrl url, (oldsite) ->
				if oldsite
					site oldsite
				else
					getIpAndInsert url, (newsite) ->
						site newsite

		checkIfAnswerIsValid = (ip, answer, valid) ->
			console.log answer
			test = ''
			checkIfIpIsValid(i, answer.primary_result, answer.secondary_result, (validAnswer) ->
				test = validAnswer
				valid test if 'fail'
			) for i in ip
			valid test

		checkIfIpIsValid = (ip, prime, second, valid) ->
			testPrime = _.indexOf(_.toArray(prime.addresses), ip) > -1 if not prime.timeout
			testSecond = _.indexOf(_.toArray(second.addresses), ip) > -1 if not second.timeout
			testResult = switch
				when prime.timeout and second.timeout then 'both timeout'
				when prime.timeout or second.timeout then 'ok' if testPrime or testSecond
				when testPrime and testSecond then 'ok'
				else 'fail'
			valid testResult

		getIpAndInsert = (url, data) ->
			app.dao.getGlobalServers (globalServers) ->
				resolveGlobalServers url, globalServers, (answer) ->
					getHash url, (hash) ->
						console.log hash
						app.dao.insertAndGetSite url, answer, hash, (site) ->
							data site

		getClientIP = (req, ip) ->
			ipAddress = null
			forwardedIpsStr = req.header 'x-forwarded-for'
			if forwardedIpsStr
				forwardedIps = forwardedIpsStr.split ','
				ipAddress = forwardedIps[0]
			ipAddress = req.connection.remoteAddress if not ipAddress
			#ipAddress = '81.247.34.211' #BELGIQUE
			#ipAddress = '91.121.208.6' #FRANCE
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

		getIpISP = (ip, isp) ->
			dns.reverse ip, (err, domains) ->
					throw err if err
					#console.log domains
					segments = domains[0].split '.'
					isp segments[segments.length-2]

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
						result = _.union(result, answer1.addresses) if answer1.addresses
						callback()
				,(callback) ->
					resolve url, server.secondary_ip, (answer2) ->
						result = _.union(result, answer2.addresses) if answer2.addresses
						callback()
				], (err) ->
					throw err if err 
					answers result

		treatLocalServer = (url, server, serverObject) ->
			oneServer = new Object()
			oneServer.valid = null
			oneServer.name = server.name
			oneServer.primary_ip = server.primary_ip
			oneServer.secondary_ip = server.secondary_ip
			resolve url, server.primary_ip, (answer1) ->
				oneServer.primary_result = answer1
				resolve url, server.secondary_ip, (answer2) ->
					oneServer.secondary_result = answer2
					serverObject oneServer

		resolve = (url, server, data) ->
			question = dns_.Question({
				name: url,
				type: 'A'})
			response = new Object()
			response.timeout = false
			start = Date.now()
			req = dns_.Request({
				question: question,
				server: {address: server},
				timeout: 2000
				})
			req.on('timeout', () ->
				response.timeout = true
			)
			req.on('message', (err, answer) ->
				addresses = []
				getAddress(a, (address) ->
					addresses.push(address) if not _.isUndefined(address)
				) for a in answer.answer
				response.addresses = addresses
			)
			req.on('end', () ->
				delta = Date.now() - start
				response.time = delta.toString()
				data response
			)
			req.send()

		getAddress = (answer, address) ->
			address answer.address

		@getIPInfos = (ip, infos) ->
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

		getHash = (url, hash) ->
			#hash('tpb hash') if url.toString() is 'www.thepiratebay.se'
			request.get "http://#{url}", (error, response, body) ->
				if not error and response.statusCode is 200
					hash md5 body
