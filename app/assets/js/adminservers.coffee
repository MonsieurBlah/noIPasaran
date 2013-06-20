# call edit modal
$('.edit').on 'click', (event) ->
	$('#edit-modal .modal-body').load('/admin/servers/modal/' + $(this).data('server-id'))
	$('#edit-modal').modal('show')

# submit edit modal
submitEdit = (dataToSend) ->
	$.post '/admin/servers/edit', dataToSend, (data) ->
		$('#edit-modal').modal('hide')

$('#editform').on "submit", (event) ->
	event.preventDefault()
	submitEdit($(this).serialize())

# delete a server
$('.delete').on 'click', (event) ->
	button = $(this)
	serverId = button.data("server-id")
	$.post '/admin/servers/delete/' + serverId, (data) ->
		if data
			button.parent('td').parent('tr').remove()

# datatables
$(document).ready ->	
  $("#servers-table").dataTable({
  	"bPaginate" : false,
  	"bLengthChange": false,
  	"bInfo": false
  	})

# OFF/ON switches
$('.off').on 'click', (event) ->
	if not $(this).hasClass 'active'
		serverId = $(this).data("server-id")
		$.post '/admin/servers/toggle/' + serverId
		$(this).next().removeClass('btn-success')
		$(this).addClass('btn-danger')

$('.on').on 'click', (event) ->
	if not $(this).hasClass 'active'
		serverId = $(this).data("server-id")
		$.post '/admin/servers/toggle/' + serverId
		$(this).prev().removeClass('btn-danger')
		$(this).addClass('btn-success')