$('.delete').on 'click', (event) ->
	siteId = $(this).data("site-id")
	console.log siteId
	$.post '/admin/sites/delete/' + siteId, (data) ->
		console.log data