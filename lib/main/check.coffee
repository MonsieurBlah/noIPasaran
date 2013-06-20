toobusy = require 'toobusy'
request = require 'request'

module.exports = (app) ->
	class app.check

		@routine = () ->
			setInterval(cleanSites, 86400000) # 1 DAY = 86400000ms

		# clean the sites db by checking the date, the hashes and IP
		# DO THE IP VERIFICATION !!!
		# ADD TOOBUSY
		cleanSites = (data) ->
			console.info 'Start cleaning sites database'
			date = Date.now()# - 1000 * 60 * 60 * 24
			app.dao.cleanSitesDate (res) ->
				deletionDone = res
				app.dao.getSitesProblem (sites) ->
					sitesToCleanCpt = sites.length
					updateDone = 0
					okDone = 0
					updateHash(site, (result)->
						if result == 'updated'
							updateDone++
						else
							okDone++
						if okDone + updateDone == sitesToCleanCpt
							console.info "Sites database cleaned, #{deletionDone} deleted, #{updateDone} updated, #{okDone} unchanged"
							data()	
					) for site in sites

		# update the hash of a site if the result is different of the existing one
		updateHash = (site, result) ->
			console.info site.url
			id = site.site_id
			getHash site.url, (hash) ->
				if site.hash != hash
					app.dao.updateSite id, hash, (data) ->
						result 'updated'
				else
					result 'ok'

		getHash = (url, hash) ->
			app.ip.getRawUrl url, (raw) ->
				urltoget = "http://noiproxy.ap01.aws.af.cm/hash/#{raw}"
				request.get urltoget, (error, response, body) ->
					if not error and response.statusCode is 200
						hash body

		@cleanSites = (data) ->
			cleanSites (result) ->
				data result
