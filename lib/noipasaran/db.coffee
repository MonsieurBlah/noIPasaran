mysql = require 'mysql'

connection = mysql.createConnection({
	host     : 'mysql2.alwaysdata.com',
	user     : 'brnrd_noip_app',
	password : 'test',
	database : 'brnrd_noipasaran'})

queryInsertTemp = 'INSERT INTO dns_servers_temp SET ?'
queryInsertFinal = 'INSERT INTO dns_servers_final SET ?'
queryGetTemps = 'SELECT * FROM dns_servers_temp'
queryGetFinals = 'SELECT * FROM dns_servers_final'
queryGetServerFromTemp = 'SELECT * FROM dns_servers_temp WHERE dns_server_temp_id = ?'


exports.insertServer = (data, isTemp, id) ->
	query = null
	if isTemp
		query = queryInsertTemp
	else
		query = queryInsertFinal
	if data.is_isp == 'on'
		data.is_isp = 1
	else 
		data.is_isp = 0
	connection.query(query, data, (err, result) ->
		if err 
			throw err

		id(result.insertId))

exports.getServers = (isTemp, data) ->
	query = null
	if isTemp
		query = queryGetTemps
	else
		query = queryGetFinals
	connection.query(query, (err, rows, fields) ->
		if err 
			throw err

		data(rows))

exports.valServer = (id, res) ->
	console.log id
	connection.query(queryGetServerFromTemp, id, (err, result) ->
		if err
			throw err 

		console.log result
		connection.query(queryInsertFinal, result, (err, result) ->
			if err 
				throw err 

			console.log result
			result
		 )
	
	)

