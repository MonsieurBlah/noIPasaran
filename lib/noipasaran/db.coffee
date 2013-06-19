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
		queryGetServerByIp = 'SELECT * FROM dns_servers WHERE primary_ip = ? OR secondary_ip = ? and valid = 1'
		queryGetServerByName = 'SELECT * FROM dns_servers WHERE LOWER(name) = LOWER(?) and valid = 1'
		
		###########
		# Servers #
		###########
		@insertServer = (data, id) ->
			if data.is_isp is 'on'
				data.is_isp = 1
			else if data.is_isp
				data.is_isp = 0
			connection.query queryInsertServer, data, (err, result) ->
				throw err if err
				id result.insertId

		@getServers = (data) ->
			connection.query queryGetServers, (err, rows, fields) ->
				throw err if err
				data rows

		@getServer = (id, data) ->
			connection.query queryGetServer, id, (err, rows, fields) ->
				throw err if err
				data rows

		@getLocalServers = (location, data) ->
			connection.query queryGetServersWhereLocation, location, (err, rows, fields) ->
				throw err if err
				data rows

		@getGlobalServers = (data) ->
			connection.query queryGetGlobalServers, (err, rows, fields) ->
				throw err if err
				data rows

		@getValidServers = (data) ->
			connection.query queryValServer, (err, rows, fields) -> 
				throw err if err
				data rows

		@toggleServer = (id, res) ->
			connection.query queryToggleServer, id, (err, result) ->
				throw err if err 
				result

		@editServer = (data, resData) ->
			if data.is_isp == 'on'
				data.is_isp = 1
			else 
				data.is_isp = 0
			id = data.dns_server_id
			delete data.dns_server_id
			connection.query queryEditServer, [data, id], (err, result) ->
				throw err if err
				resData result.affectedRows

		@delServer = (id, data) ->
			connection.query queryDeleteServer, id, (err, result) ->
				throw err if err
				data result

		@getServerByIp = (ip, data) ->
			connection.query queryGetServerByIp, [ip, ip], (err, result) ->
				throw err if err
				data result

		@getServerByName = (name, data) ->
			connection.query queryGetServerByName, name, (err, result) ->
				throw err if err 
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
		queryFixSite = 'UPDATE sites SET haz_problem = 1 WHERE site_id = ?'
		queryCleanSites = 'DELETE FROM sites WHERE haz_problem = 0'
		queryCleanSitesDate = 'DELETE FROM sites WHERE haz_problem = 0 AND date < NOW() - INTERVAL 1 DAY'
		queryUpdateSite = 'UPDATE sites SET hash = ? WHERE site_id = ?'
		queryGetSitesProblem = 'SELECT * FROM sites WHERE haz_problem = 1'

		@getSites = (data) ->
			connection.query queryGetSites, (err, rows, fields) ->
				throw err if err 
				row.ip = row.ip.split(',') for row in rows
				data rows

		@insertSite = (url, ip, hash, data) ->
			site = {
				'url': url,
				'ip': ip,
				'hash': hash
			}
			connection.query queryInserSite, site, (err, result) ->
				throw err if err 
				data result

		@delSite = (id, data) ->
			connection.query queryDeleteSite, id, (err, result) ->
				throw err if err
				data result

		@getSiteByUrl = (url, data) ->
			connection.query queryGetSiteByUrl, url, (err, rows, fields) ->
				throw err if err
				row.ip = row.ip.split(',') for row in rows
				data rows[0]

		@getSiteByIp = (ip, data) ->
			connection.query queryGetSiteByIp, ip, (err, rows, fields) ->
				throw err if err
				row.ip = row.ip.split(',') for row in rows
				data rows[0]

		@insertAndGetSite = (url, ip, hash, data) ->
			site = {
				'url': url,
				'ip': ip.toString()
				'hash': hash
			}
			connection.query queryInserSite, site, (err, result) ->
				throw err if err
				connection.query queryGetSiteById, result.insertId, (err, rows, fields) ->
					throw err if err
					row.ip = row.ip.split(',') for row in rows
					data rows[0]

		@fixSite = (id, data) ->
			connection.query queryFixSite, id, (err, result) ->
				throw err if err
				data result

		@cleanSites = (data) ->
			connection.query queryCleanSites, (err, result) ->
				throw err if err
				data result

		@cleanSitesDate = (data) ->
			connection.query queryCleanSitesDate, (err, result) ->
				throw err if err
				data result.affectedRows

		@updateSite = (id, hash, data) ->
			connection.query queryUpdateSite, [hash, id], (err, result) ->
				throw err if err
				data result.affectedRows

		@getSitesProblem = (data) ->
			connection.query queryGetSitesProblem, (err, rows, fields) ->
				throw err if err 
				row.ip = row.ip.split(',') for row in rows
				data rows
