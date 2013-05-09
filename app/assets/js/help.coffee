
submitHandler = (dataToSend) ->
	console.log dataToSend
	$.post '/help', dataToSend
	(data) ->
		console.log 'DATA: ' + data

# Help form submit
$('#help-form').on "submit", (event) ->
	event.preventDefault()
	submitHandler($(this).serialize())