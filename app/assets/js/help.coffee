submitHandler = (dataToSend) ->
	if $('#checkbox').hasClass('checked')
		dataToSend += '&is_isp=1'
	$.post '/help', dataToSend,
	(data) ->
		if data
			# clean the form
			$('#help-form').find('input:text').val('')
			$('#help-form').find('select').val('Global')
			$('#help-form').find('input:checkbox').removeAttr('checked')

# Help form submit
$('#help-form').on "submit", (event) ->
	event.preventDefault()
	submitHandler($(this).serialize())
