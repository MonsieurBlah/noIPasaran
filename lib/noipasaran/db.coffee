mysql = require 'mysql'

connection = mysql.createConnection({
  host     : 'mysql2.alwaysdata.com',
  user     : 'brnrd_noip_app',
  password : 'test',
  database : 'brnrd_noipasaran'})

exports.insert_dns_temp = (data, id) ->
  connection.query('INSERT INTO dns_servers_temp SET ?', data, (err, result) ->
    if err 
      throw err

    console.log result
    result.insertId
  )
