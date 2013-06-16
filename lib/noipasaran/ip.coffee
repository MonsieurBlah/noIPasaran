request = require 'request'
dns = require 'dns'
async = require 'async'
_ = require 'underscore'
dns_ = require 'native-dns'
md5 = require 'MD5'

module.exports = (app) ->
	class app.ip

		# Use to get Data base on URL and ISP or Country DNS servers
		@getLocalData = (site, url, servers, data) ->
			result = new Object()
			# resolve the url on all the servers
			resolveLocalServers url, servers, (localAnswers) ->
				fixed = site.haz_problem
				# check the validity of all the answers
				checkIfAnswerIsValid(site.ip, answer, (valid) ->
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

		# check if the answers are valid
		checkIfAnswerIsValid = (ips, answer, valid) ->
			ipArr = ips.split ','
			test = ''
			checkIfIpIsValid(ip, answer.primary_result, answer.secondary_result, (validAnswer) ->
				test = validAnswer
				valid test if 'fail'
			) for ip in ipArr
			valid test

		# check if an IP is valid, timeout or fail
		checkIfIpIsValid = (ip, prime, second, valid) ->
			testPrime = _.indexOf(_.toArray(prime.addresses), ip) > -1 if not prime.timeout
			testSecond = _.indexOf(_.toArray(second.addresses), ip) > -1 if not second.timeout
			testResult = switch
				when prime.timeout and second.timeout then 'both timeout'
				when prime.timeout or second.timeout then 'ok' if testPrime or testSecond
				when testPrime and testSecond then 'ok'
				else 'fail'
			valid testResult

		# get the ip of an URL and insert it in the db
		getIpAndInsert = (url, data) ->
			# get the global servers
			app.dao.getGlobalServers (globalServers) ->
				# resolve the URL on the global servers
				resolveGlobalServers url, globalServers, (answer) ->
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
			ipAddress = '81.247.34.211' #BELGIQUE - BELGACOM
			#ipAddress = '91.121.208.6' #FRANCE - KIMSUFI
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
				throw err if err
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
			console.log url
			getRawUrl url, (raw) ->
				console.log raw
				urltoget = "http://noiproxy.herokuapp.com/html/#{raw}"
				request.get urltoget, (error, response, body) ->
					if not error and response.statusCode is 200
						hash md5 body


		# update the hash of a site if the result is different of the existing one
		updateHash = (site, result) ->
			id = site.site_id
			getHash site.url, (hash) ->
				if site.hash != hash
					app.dao.updateSite id, hash, (data) ->
						result data

		# clean the sites db by checking the date, the hashes and IP
		# DO THE IP VERIFICATION !!!
		@cleanSites = (data) ->
			date = Date.now() - 1000 * 60 * 60 * 24
			app.dao.cleanSitesDate date, (res) ->
				app.dao.getSites (sites) ->
					updateHash(site, (result)->
					) for site in sites
				data()			