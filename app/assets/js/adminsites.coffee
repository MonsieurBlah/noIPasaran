$('.delete').on 'click', (event) ->
	siteId = $(this).data("site-id")
	button = $(this)
	console.log siteId
	$.post '/admin/sites/delete/' + siteId, (data) ->
		console.log data
		if data
			console.log button
			button.parent('td').parent('tr').remove()

$(document).ready ->	
  $("#sites-table").dataTable({
  	"bPaginate" : false,
  	"bLengthChange": false,
  	"bInfo": false
  	})