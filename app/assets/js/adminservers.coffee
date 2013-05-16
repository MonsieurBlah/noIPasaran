$('.validate').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	if $(this).hasClass('active')
		$.post '/admin/servers/unvalidate/' + serverId
	else
		$.post '/admin/servers/validate/' + serverId

$('.edit').on 'click', (event) ->
	$('#edit-modal .modal-body').load('/admin/servers/modal/' + $(this).data('server-id'))
	$('#edit-modal').modal('show')

submitEdit = (dataToSend) ->
	console.log dataToSend
	$.post '/admin/servers/edit', dataToSend, 
	(data) ->
		console.log data
		$('#edit-modal').modal('hide')

$('#editform').on "submit", (event) ->
	event.preventDefault()
	console.log 'SUBMIT'
	submitEdit($(this).serialize())

$('.delete').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/servers/delete/' + serverId

$(document).ready ->	
  $("#servers-table").dataTable({
  	"bPaginate" : false,
  	"bLengthChange": false,
  	"bInfo": false
  	})
