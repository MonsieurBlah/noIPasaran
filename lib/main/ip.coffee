request = require 'request'
dns = require 'dns'
async = require 'async'
_ = require 'underscore'
dns_ = require 'native-dns'

module.exports = (app) ->
	class app.ip

		# Use to get Data base on URL and ISP or Country DNS servers
		@getLocalData = (site, url, servers, data) ->
			result = new Object()
			# resolve the url on all the servers
			resolveLocalServers url, servers, (localAnswers) ->
				fixed = site.haz_problem
				# check the validity of all the answers
				checkIfAnswerIsValid(site.ip, answer, site.hash, (valid) ->
					answer.valid = valid
					# set haz_problem if the answer is not valid and not yet fixed
					app.dao.fixSite(site.site_id, (done) ->
						fixed is on if done
					) if valid is 'fail' and not fixed
				) for answer in localAnswers
				result.local = localAnswers
				data result

		@getIspOrCountry = (req, answer) ->
			result = new Object()
			result.isCountry = false
			result.isIsp = false
			# get the client's IP
			getClientIP req, (clientIP) ->
				result.clientip = clientIP
				# in parallel get the client's IP country and ISP
				async.parallel [
					(callback) ->
						getIpCountry clientIP, (country) ->
							result.country = country
							result.isCountry = true
							callback()
					,(callback) ->
						getIpISP clientIP, (isp) ->
							result.isp = isp
							callback()
				], (err) ->
					throw err if err
					# get the server base on the name of the ISP
					app.dao.getServerByName result.isp, (ispServers) ->
						# if there is an ISP with this name
						result.isIsp = true if ispServers.length > 0
						answer result

		# get a site from the db or create it base on a URL
		@getSite = (url, site) ->
			app.dao.getSiteByUrl url, (oldsite) ->
				# it there is an existing site returns it
				if oldsite
					site oldsite
				else
					# create a new site and insert in in the db then returns it
					getIpAndInsert url, (newsite) ->
						site newsite

		# extract the hostname from a URL as http://www.example.com -> www.example.com
		getRawUrl = (url, raw) ->
			urlArr = url.split '://'
			rawUrl = urlArr[1] if urlArr.length > 1
			raw rawUrl

		# extract the hostname from a URL as http://www.example.com -> www.example.com
		@getRawUrl = (url, raw) ->
			urlArr = url.split '://'
			rawUrl = urlArr[1] if urlArr.length > 1
			raw rawUrl

		# check if the answers are valid
		checkIfAnswerIsValid = (ips, answer, hash, valid) ->
			test = ''
			checkIfIpIsValid(ip, answer.primary_result, answer.secondary_result, hash, (validAnswer) ->
				test = validAnswer
				valid test if 'fail'
			) for ip in ips
			valid test

		# check if an IP is valid, timeout or fail
		checkIfIpIsValid = (ip, prime, second, hash, valid) ->
			if not prime.timeout
				testPrime = _.indexOf(_.toArray(prime.addresses), ip) > -1 
			if not second.timeout
				testSecond = _.indexOf(_.toArray(second.addresses), ip) > -1 
			testPrime = 'false' if _.isUndefined testPrime
			testSecond = 'false' if _.isUndefined testSecond
			testResult = switch
				when prime.timeout and second.timeout then 'both timeout'
				when testPrime and second.timeout then 'ok'
				when testSecond and prime.timeout then 'ok'
				when testPrime and testSecond then 'ok'
				else 'fail'
			#if testResult is 'fail'
			#	checkValidWithHash hash, prime, second, (hashValid) -> 
			#		testResult = hashValid
			valid testResult

		checkValidWithHash = (hash, prime, second, valid) ->
			ips = _.union prime.addresses, second.addresses
			getHashIp(ip, (ipHash) ->
				if hash == ipHash
					valid 'ok'
				else 
					valid 'fail'
			) for ip in ips

		# get the ip of an URL and insert it in the db
		getIpAndInsert = (url, data) ->
			# get the global servers
			app.dao.getGlobalServers (globalServers) ->
				# resolve the URL on the global servers
				resolveGlobalServers url, globalServers, (answer) ->
					if _.isEmpty answer
						data answer
					else 
						# hash the HTML of the site
						getHash url, (hash) ->
							# insert those info in the db
							app.dao.insertAndGetSite url, answer, hash, (site) ->
								# returns the created site
								data site

		# get the client IP
		getClientIP = (req, ip) ->
			ipAddress = null
			forwardedIpsStr = req.header 'x-forwarded-for'
			if forwardedIpsStr
				forwardedIps = forwardedIpsStr.split ','
				ipAddress = forwardedIps[0]
			ipAddress = req.connection.remoteAddress if not ipAddress
			# UNCOMMENT THE FOLLOWING LINE TO RUN THE TESTS ON LOCAL (modify the IP and add yours)
			# ipAddress = '81.247.34.211' #BELGIQUE - BELGACOM
			ip ipAddress

		# match the pattern of an IP
		@isIp = (str, match) ->
			matchres = /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/.test(str)
			match matchres

		# get the country of an IP using external service
		getIpCountry = (ip, country) ->
			url = 'http://freegeoip.net/json/' + ip
			request.get url, (error, response, body) ->
				if !error && response.statusCode == 200
					data = JSON.parse body
					country data.country_name

		# try to get the ISP of an IP with a reverse
		getIpISP = (ip, isp) ->
			dns.reverse ip, (err, domains) ->
				if err
					isp ' '
				else
					segments = domains[0].split '.'
					isp segments[segments.length-2]

		# resolve an URL on the global servers
		resolveGlobalServers = (url, servers, data) ->
			result = []
			count = 0
			treatGlobalServer(url, server, (resolved) ->
				# make a union between the existing results and the new answers
				result = _.union(resolved, result)
				count++
				data result if count is servers.length
			) for server in servers

		# resolve an URL on the local servers
		resolveLocalServers = (url, servers, resolved) ->
			result = []
			treatLocalServer(url, server, (serverObject) ->
				result.push serverObject
				resolved result if result.length is servers.length
			) for server in servers

		# resolve on both servers of a global server
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

		# resolve on both servers of a local server
		treatLocalServer = (url, server, serverObject) ->
			oneServer = new Object()
			oneServer.valid = null
			oneServer.name = server.name
			oneServer.primary_ip = server.primary_ip
			oneServer.secondary_ip = server.secondary_ip
			async.parallel [
				(callback) ->
					resolve url, server.primary_ip, (answer1) ->
						oneServer.primary_result = answer1
						callback()
				,(callback) ->
					resolve url, server.secondary_ip, (answer2) ->
						oneServer.secondary_result = answer2
						callback()
				], (err) ->
					throw err if err 
					serverObject oneServer

		# resolve a URL on a DNS server
		resolve = (url, server, data) ->
			getRawUrl url, (raw) ->
				question = dns_.Question({
					name: raw,
					type: 'A'})
				response = new Object()
				response.timeout = false
				start = Date.now()
				req = dns_.Request({
					question: question,
					server: {address: server},
					timeout: 1000
					})
				req.on('timeout', () ->
					response.timeout = true
				)
				req.on('message', (err, answer) ->
					addresses = []
					getAddress(a, (address) ->
						addresses.push(address) if not _.isUndefined(address)
					) for a in answer.answer
					response.addresses = addresses.sort()
				)
				req.on('end', () ->
					delta = Date.now() - start
					response.time = delta.toString()
					data response
				)
				req.send()

		# get the address of an answer
		getAddress = (answer, address) ->
			address answer.address

		# get the localisation infos of an IP
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

		# get the md5 hash of the HTML code of an URL
		getHash = (url, hash) ->
			getRawUrl url, (raw) ->
				urltoget = "http://noiproxy.ap01.aws.af.cm/hash/#{raw}"
				request.get urltoget, (error, response, body) ->
					if not error and response.statusCode is 200
						hash body

		# body the md5 hash of the HTML code of an URL
		getHashIp = (ip, hash) ->
			urltoget = "http://noiproxy.ap01.aws.af.cm/hash/#{ip}"
			request.get urltoget, (error, response, body) ->
				if not error and response.statusCode is 200
					hash body

		# update the hash of a site if the result is different of the existing one
		updateHash = (site, result) ->
			id = site.site_id
			getHash site.url, (hash) ->
				if site.hash != hash
					app.dao.updateSite id, hash, (data) ->
						result data

				