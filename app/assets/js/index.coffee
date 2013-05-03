$.getJSON("http://jsonip.com?callback=?", (data) ->
	console.log data
	$.getJSON("http://freegeoip.net/json/" + data.ip, (fulldata) ->
		console.log fulldata))
