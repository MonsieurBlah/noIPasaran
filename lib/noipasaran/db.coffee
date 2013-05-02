mysql = require 'mysql'

connection = mysql.createConnection({
  host     : 'mysql2.alwaysdata.com',
  user     : 'brnrd_noip_app',
  password : 'test',
  database : 'brnrd_noipasaran'})

insert_temp = 'INSERT INTO dns_servers_temp SET ?'
insert_final = 'INSERT INTO dns_servers_final SET ?'
get_temps = 'SELECT * FROM dns_servers_temp'
get_finals = 'SELECT * FROM dns_servers_final'


exports.insert_server = (data, isTemp, id) ->
  query = null
  if isTemp
    query = insert_temp
  else
    query = insert_final
  if data.is_isp == 'on'
    data.is_isp = 1
  else 
    data.is_isp = 0
  connection.query(query, data, (err, result) ->
    if err 
      throw err

    id(result.insertId))

exports.get_servers = (isTemp, data) ->
  query = null
  if isTemp
    query = get_temps
  else
    query = get_finals
  connection.query(query, (err, rows, fields) ->
    if err 
      throw err

    data(rows))
