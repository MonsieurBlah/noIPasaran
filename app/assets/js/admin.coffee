$('.validate').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/temp/validate/' + serverId