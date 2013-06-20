module.exports = (app) ->
	class app.distance

		R = 6371

		@get = (lat1, lon1, lat2, lon2, distance) ->
			dLat = toRad(lat2-lat1)
			dLon = toRad(lon2-lon1)
			lat1 = toRad(lat1)
			lat2 = toRad(lat2)
			a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
			c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
			distance Math.round(R * c)

		toRad = (value) ->
			value * Math.PI / 180
