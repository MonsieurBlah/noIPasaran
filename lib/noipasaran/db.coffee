mysql = require 'mysql'

module.exports = (app) ->
	class app.dao

		connection = mysql.createConnection {
			host     : 'mysql2.alwaysdata.com',
			user     : 'brnrd_noip_app',
			password : 'test',
			database : 'brnrd_noipasaran'}

		queryInsertServer = 'INSERT INTO dns_servers SET ?'
		queryGetServers = 'SELECT * FROM dns_servers'
		queryGetServer = 'SELECT * FROM dns_servers WHERE dns_server_id = ?'
		queryValServer = 'UPDATE dns_servers SET valid = 1 WHERE dns_server_id = ?'
		queryUnValServer = 'UPDATE dns_servers SET valid = 0 WHERE dns_server_id = ?'
		queryEditServer = 'UPDATE dns_servers SET ? WHERE dns_server_id = ?'
		queryDeleteServer = 'DELETE FROM dns_servers WHERE dns_server_id = ?'
		queryGetServersWhereLocation = 'SELECT * FROM dns_servers WHERE location = ? AND valid = 1'
		queryGetGlobalServers = 'SELECT * FROM dns_servers WHERE location = \'Global\' AND valid = 1'
		queryGetValidServers = 'SELECT * FROM dns_servers WHERE valid = 1'
		
		###########
		# Servers #
		###########
		@insertServer = (data, id) ->
			if data.is_isp == 'on'
				data.is_isp = 1
			else 
				data.is_isp = 0
			connection.query queryInsertServer, data, (err, result) ->
				if err 
					throw err
				id result.insertId

		@getServers = (data) ->
			connection.query queryGetServers, (err, rows, fields) ->
				if err 
					throw err
				data rows

		@getServer = (id, data) ->
			connection.query queryGetServer, id, (err, rows, fields) ->
				if err 
					throw err
				data rows

		@getServersWhereLocation = (location, data) ->
			connection.query queryGetServersWhereLocation, location, (err, rows, fields) ->
				if err 
					throw err
				data rows

		@getGlobalServers = (data) ->
					connection.query queryGetGlobalServers, (err, rows, fields) ->
						if err 
							throw err
						data rows

		@getValidServers = (data) ->
			connection.query queryValServer, (err, rows, fields) -> 
				if err
					throw err
				data rows

		@valServer = (id, res) ->
			connection.query queryValServer, id, (err, result) ->
				if err
					throw err 
				result

		@unvalServer = (id, res) ->
			connection.query queryUnValServer, id, (err, result) ->
				if err
					throw err 
				result

		@editServer = (data, resData) ->
			if data.is_isp == 'on'
				data.is_isp = 1
			else 
				data.is_isp = 0
			id = data.dns_server_id
			delete data.dns_server_id
			connection.query queryEditServer, [data, id], (err, result) ->
				if err 
					throw err 
				resData result.affectedRows

		@delServer = (id, data) ->
			connection.query queryDeleteServer, id, (err, result) ->
				if err 
					throw err
				data result

		#########
		# Sites #
		#########
		queryGetSites = 'SELECT * FROM sites'
		queryInserSite = 'INSERT INTO sites SET ?'
		queryGetSite = 'SELECT * FROM sites WHERE url = ?'
		queryDeleteSite = 'DELETE FROM sites WHERE site_id = ?'

		@getSites = (data) ->
			connection.query queryGetSites, (err, rows, fields) ->
				if err 
					throw err 
				data rows

		@insertSite = (url, ip, id) ->
			checkIfSiteExists url, (exists) ->
				if !exists
					data = {
						'url': url,
						'ip': ip
					}
					connection.query queryInserSite, data, (err, result) ->
						if err 
							throw err 
						id result.insertId

		@delSite = (id, data) ->
			connection.query queryDeleteSite, id, (err, result) ->
				if err 
					throw err 
				data result

		checkIfSiteExists = (url, exists) ->
			connection.query queryGetSite, url, (err, rows, fields) ->
				if err 
					throw err
				exists rows.length > 0
