var express = require('express')
	,	app = express.createServer();	

app.get('/', function(req, res) {
	res.send('Hello world');
});

app.listen(3000);