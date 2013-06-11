$('.active').on 'switch-change', (event, data) ->
	serverId = $(this).data("server-id")
	$.post '/admin/servers/toggle/' + serverId

$('.edit').on 'click', (event) ->
	$('#edit-modal .modal-body').load('/admin/servers/modal/' + $(this).data('server-id'))
	$('#edit-modal').modal('show')

submitEdit = (dataToSend) ->
	console.log dataToSend
	$.post '/admin/servers/edit', dataToSend, (data) ->
		console.log data
		$('#edit-modal').modal('hide')

$('#editform').on "submit", (event) ->
	event.preventDefault()
	console.log 'SUBMIT'
	submitEdit($(this).serialize())

$('.delete').on 'click', (event) ->
	button = $(this)
	serverId = button.data("server-id")
	$.post '/admin/servers/delete/' + serverId, (data) ->
		console.log data
		if data
			button.parent('td').parent('tr').remove()

$(document).ready ->	
  $("#servers-table").dataTable({
  	"bPaginate" : false,
  	"bLengthChange": false,
  	"bInfo": false
  	})
