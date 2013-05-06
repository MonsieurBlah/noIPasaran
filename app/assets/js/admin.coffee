$('.validate').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/servers/validate/' + serverId
	(data) ->
		location.reload()

$('.delete').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/servers/delete/' + serverId
