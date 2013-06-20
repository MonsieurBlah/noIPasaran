
module.exports = (app) ->
	class app.staticmap

		base_url = 'http://maps.googleapis.com/maps/api/staticmap'
		key = 'key=AIzaSyDkzxNkiE6XtBgM_FxME9zhaZZn1NJHQUI'

		@getMapUrl = (clientip, serverip, data) ->
			clientip = '81.247.98.175'
			app.ip.getIPInfos clientip, (clientInfos) ->
				app.ip.getIPInfos serverip, (serverInfos) ->
					client = "#{clientInfos.latitude},#{clientInfos.longitude}"
					server = "#{serverInfos.latitude},#{serverInfos.longitude}"
					fullUrl = "#{base_url}?scale=1&#{key}&size=640x400&markers=color:red%7C#{client}&markers=color:red%7C#{server}"
					fullUrl = "#{fullUrl}&path=color:0x0000ff|weight:5|#{client}|#{server}&sensor=false"
					result = new Object()
					result.url = fullUrl
					result.client = clientInfos
					result.server = serverInfos
					data result