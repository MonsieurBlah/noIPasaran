module.exports = (app) ->
	class app.ipmanip

		@getClientIP = (req, ip) ->
			ipAddress = null
			forwardedIpsStr = req.header('x-forwarded-for')
			console.log forwardedIpsString
			if forwardedIpsString
				forwardedIps = forwardedIpsString.split(',')
				ipAddress = forwardedIpsþ[0]
			if !ipAddress
				ipAddress = req.connection.remoteAddress
			ip(ipAddress)

