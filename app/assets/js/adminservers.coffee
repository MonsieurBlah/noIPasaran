$('.validate').on 'click', (event) ->
	serverId = $(this).data("server-id")
	console.log serverId
	$.post '/admin/servers/validate/' + serverId

$('.edit').on 'click', (event) ->
	$('#edit-modal .modal-body').load('/admin/servers/modal/' + $(this).data('server-id'))
	$('#edit-modal .modal-footer #submit').attr('form','edit-form')
	$('#edit-modal').modal('show')

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

submitEdit = (dataToSend) ->
	console.log dataToSend
	$.post '/admin/servers/edit', dataToSend
	(data) ->
		console.log data
		$('#edit-modal').modal('hide')

$('#edit-form').on 'submit', (event) ->
	event.preventDefault()
	submitEdit($(this).serialize())
