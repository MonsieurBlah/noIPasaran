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
		queryToggleServer = 'UPDATE dns_servers SET valid = IF(valid = 1, 0, 1) WHERE dns_server_id = ?'
		queryEditServer = 'UPDATE dns_servers SET ? WHERE dns_server_id = ?'
		queryDeleteServer = 'DELETE FROM dns_servers WHERE dns_server_id = ?'
		queryGetServersWhereLocation = 'SELECT * FROM dns_servers WHERE location = ? AND valid = 1'
		queryGetGlobalServers = 'SELECT * FROM dns_servers WHERE location = \'Global\' AND valid = 1'
		queryGetValidServers = 'SELECT * FROM dns_servers WHERE valid = 1'
		queryGetServerByIp = 'SELECT * FROM dns_servers WHERE primary_ip = ? OR secondary_ip = ?'
		queryGetServerByName = 'SELECT * FROM dns_servers WHERE LOWER(name) = LOWER(?)'
		
		###########
		# Servers #
		###########
		@insertServer = (data, id) ->
			if data.is_isp is 'on'
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

		@getLocalServers = (location, data) ->
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

		@toggleServer = (id, res) ->
			connection.query queryToggleServer, id, (err, result) ->
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

		@getServerByIp = (ip, data) ->
			connection.query queryGetServerByIp, [ip, ip], (err, result) ->
				if err 
					throw err 
				data result

		@getServerByName = (name, data) ->
			console.log name
			connection.query queryGetServerByName, name, (err, result) ->
				if err 
					throw err 
				data result
				
		#########
		# Sites #
		#########
		queryGetSites = 'SELECT * FROM sites'
		queryInserSite = 'INSERT INTO sites SET ?'
		queryGetSiteByUrl = 'SELECT * FROM sites WHERE url = ?'
		queryGetSiteByIp = 'SELECT * FROM sites WHERE ip LIKE "%?%"'
		queryGetSiteById = 'SELECT * FROM sites WHERE site_id = ?'
		queryDeleteSite = 'DELETE FROM sites WHERE site_id = ?'

		@getSites = (data) ->
			connection.query queryGetSites, (err, rows, fields) ->
				if err 
					throw err 
				row.ip = row.ip.split(',') for row in rows
				data rows

		@insertSite = (url, ip, data) ->
			site = {
				'url': url,
				'ip': ip
			}
			connection.query queryInserSite, site, (err, result) ->
				if err 
					throw err 
				data result

		@delSite = (id, data) ->
			connection.query queryDeleteSite, id, (err, result) ->
				if err 
					throw err 
				data result

		@getSiteByUrl = (url, data) ->
			connection.query queryGetSiteByUrl, url, (err, rows, fields) ->
				if err 
					throw err
				data rows[0]

		@getSiteByIp = (ip, data) ->
			query = connection.query queryGetSiteByIp, ip, (err, rows, fields) ->
				if err 
					throw err
				data rows[0]
			#console.log query.sql

		@insertAndGetSite = (url, ip, data) ->
			site = {
				'url': url,
				'ip': ip.toString()
			}
			connection.query queryInserSite, site, (err, result) ->
				if err 
					throw err 
				connection.query queryGetSiteById, result.insertId, (err, rows, fields) ->
					if err 
						throw err
					data rows[0]

