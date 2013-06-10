executer = (mot, callback) -> 
	callback mot

executer 'Hello', (callback) ->
	console.log callback