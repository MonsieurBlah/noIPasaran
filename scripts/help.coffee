
helpHandler = (dataToSend) ->
	$.post '/help', dataToSend
	(data) ->
		console.log ('OK ' + data)

$('#help-form').on "submit", (event) ->
	event.preventDefault()
	helpHandler($(this).serialize())