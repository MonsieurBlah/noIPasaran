var express = require('express')
  , stylus  = require('stylus')
  , nib     = require('nib')
  , db		= require('./db')
  , routes 	= require('./routes')
  
var app = express()

var REGEX_IP_PAGE = /\/ip=\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;
var REGEX_URL = /\/url=/;

// mongoose setup
require( './db' );

function compile(str, path) {
	return stylus(str)
	.set('filename', path)
	.use(nib())
}

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.bodyParser());
app.use(express.logger('dev'))
app.use(stylus.middleware(
	{ src: __dirname + '/public'
	, compile: compile
  }
))
app.use(express.static(__dirname + '/public'))
app.use(express.favicon(__dirname + '/public/images/favicon.ico'));

var auth = express.basicAuth(function(user, pass) {
	return user === 'admin' && pass === 'adminpwd';
});

app.get('/', routes.root);

app.get('/index', routes.index);

app.post('/query', routes.query);

app.get(REGEX_IP_PAGE, routes.ip);

app.get(REGEX_URL, routes.url);

app.get('/about', routes.about);

app.get('/help', routes.help);

app.post('/submit', routes.submit);

app.get('/admin', auth, routes.admin);

app.get('/destroy/:id', routes.destroy);

app.get('/validate/:id', routes.validate);

app.get('/edit/:id', routes.edit);

app.post('/update/:id', routes.update);

app.get('/test', auth, routes.test);

app.get('*', routes.fourOfour);

app.listen(8888)