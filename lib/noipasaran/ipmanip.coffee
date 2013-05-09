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