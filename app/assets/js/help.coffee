submitHandler = (dataToSend) ->
	console.log dataToSend
	$.post '/help', dataToSend,
	(data) ->
		console.log 'DATA: ' + data
		if data
			$('#help-form').find('input:text').val('')
			$('#help-form').find('select').val('Global')
			$('#help-form').find('input:checkbox').removeAttr('checked')
			$('#btnspan').addClass('label label-success')
			$('#btnspan').text('Thanks !')

# Help form submit
$('#help-form').on "submit", (event) ->
	event.preventDefault()
	submitHandler($(this).serialize())