mysql = require 'mysql'

module.exports = (app) ->
	class app.dao

		connection = mysql.createConnection({
			host     : 'mysql2.alwaysdata.com',
			user     : 'brnrd_noip_app',
			password : 'test',
			database : 'brnrd_noipasaran'})

		queryInsertServer = 'INSERT INTO dns_servers SET ?'
		queryGetServers = 'SELECT * FROM dns_servers'
		queryGetServer = 'SELECT * FROM dns_servers WHERE dns_server_id = ?'
		queryValServer = 'UPDATE dns_servers SET valid = 1 WHERE dns_server_id = ?'
		queryDeleteServer = 'DELETE FROM dns_servers WHERE dns_server_id = ?'


		@insertServer = (data, id) ->
			if data.is_isp == 'on'
				data.is_isp = 1
			else 
				data.is_isp = 0
			connection.query(queryInsertServer, data, (err, result) ->
				if err 
					throw err

				id(result.insertId))

		@getServers = (data) ->
			connection.query(queryGetServers, (err, rows, fields) ->
				if err 
					throw err

				data(rows))

		@valServer = (id, res) ->
			connection.query(queryValServer, id, (err, result) ->
				if err
					throw err 

				console.log result
				result)

		@delServer = (id, data) ->
			connection.query(queryDeleteServer, id, (err, data) ->
				if err 
					throw err

				console.log data
				data)

