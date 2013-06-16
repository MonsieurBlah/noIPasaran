submitHandler = (dataToSend) ->
	if $('#checkbox').hasClass('checked')
		dataToSend += '&is_isp=1'
	$.post '/help', dataToSend,
	(data) ->
		if data
			$('#help-form').find('input:text').val('')
			$('#help-form').find('select').val('Global')
			$('#help-form').find('input:checkbox').removeAttr('checked')
			# $('#btnspan').addClass('label label-success').text('Thanks !').delay(800).fadeIn(400)

# Help form submit
$('#help-form').on "submit", (event) ->
	event.preventDefault()
	submitHandler($(this).serialize())


service = new google.maps.places.AutocompleteService()
geocoder = new google.maps.Geocoder()

$('#location').typeahead(
	source: (query, process) ->
		service.getPlacePredictions(
			input: query,
			(predictions, status) ->
				if status == google.maps.places.PlacesServiceStatus.OK
					process(
						$.map(
							predictions,
							(prediction) ->
								# console.log prediction
								prediction.description
						)
					)
		)
)