# $(document).ready ->	
#   $("#servers-table").dataTable({
#   	"bPaginate" : false,
#   	"bLengthChange": false,
#   	"bInfo": false
#   	})

$('#show-modal').on 'click', (event) ->
	$('#detail-modal').modal('show')