var express = require('express')
  , stylus  = require('stylus')
  , nib     = require('nib')
  , db		= require('./db')
  , routes 	= require('./routes')
  , mongoose= require('mongoose')
  , user 	= mongoose.model('user')
  , flash = require('connect-flash')
  
var app = express()

var REGEX_IP_PAGE = /\/ip\/\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;
var REGEX_URL = /\/url/;

// mongoose setup
require( './db' );

function compile(str, path) {
	return stylus(str)
	.set('filename', path)
	.use(nib())
}

app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.bodyParser());
app.use(express.logger('dev'));
app.use(stylus.middleware(
	{ src: __dirname + '/public'
	, compile: compile
  }
))
app.use(express.cookieParser('unicorn lolcat nyan nyan'));
app.use(express.session({ cookie: { maxAge: 60000 }}));
app.use(flash());
app.use(express.static(__dirname + '/public'));
app.use(express.favicon(__dirname + '/public/images/favicon.ico'));

var auth = express.basicAuth(function(username, password) {
	return user.findOne({'username': username}, function(err, resu) {
		if (err) { return false }
		return resu.password == password
	})
});

app.get('/', routes.root);
app.get('/index', routes.index);
app.post('/query', routes.query);
app.get(REGEX_IP_PAGE, routes.ip);
app.get(REGEX_URL, routes.url);
app.get('/help', routes.help);
app.post('/help/:ip', routes.helpip);
app.post('/submit', routes.submit);
app.get('/admin', auth, routes.admin);
app.get('/admin/:db', auth, routes.admin);
app.get('/admin/:db/destroy/:id', auth, routes.destroy);
app.get('/admin/:db/validate/:id', auth, routes.validate);
app.get('/admin/:db/edit/:id', auth, routes.edit);
app.post('/admin/:db/update/:id', auth, routes.update);
app.get('/test', auth, routes.test);
app.get('*', routes.fourOfour);

app.listen(8888)