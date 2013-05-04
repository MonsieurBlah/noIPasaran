$('.validate').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/temp/validate/' + serverId
	(data) ->
		location.reload()

$('.delete-temp').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/temp/delete/' + serverId

$('.delete-final').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/final/delete/' + serverId
