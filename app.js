var express = require('express')
  , stylus  = require('stylus')
  , nib     = require('nib')
  , routes 	= require('./routes')

var app = express()

var REGEX_IP_PAGE = /\/ip=\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;
var REGEX_URL = /\/url=/;

function compile(str, path) {
	return stylus(str)
	.set('filename', path)
	.use(nib())
}

//Mongoose setup
//require('./db');

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.logger('dev'))
app.use(stylus.middleware(
	{ src: __dirname + '/public'
	, compile: compile
  }
))
app.use(express.static(__dirname + '/public'))
app.use(express.favicon(__dirname + '/public/images/favicon.ico'));

app.get('/', routes.root);

app.get('/index', routes.index);

app.get(REGEX_IP_PAGE, routes.ip);

app.get(REGEX_URL, routes.url);

app.get('/about', routes.about);

app.get('/help', routes.help);

app.get('/admin', routes.admin);

app.get('/test', routes.test);

app.get('*', routes.fourOfour);

app.listen(8888)