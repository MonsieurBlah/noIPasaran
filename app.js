var express = require('express')
  , stylus  = require('stylus')
  , nib     = require('nib')

var app = express()
var REGEX_IP = /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;
var REGEX_IP_PAGE = /\/ip=\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;
var REGEX_URL = /\/url=/;
function compile(str, path) {
	return stylus(str)
	.set('filename', path)
	.use(nib())
}
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

app.get('/', function (req, res) {
  	res.render('index',{title: 'Home'})
})
app.get('/index', function (req, res) {
  	res.render('index',{title: 'Home'})
})
app.get(REGEX_IP_PAGE, function (req, res) {
	res.render('result',{title: 'IP ', url: 'test.com', ip: req.url.substr(4,req.url.length)})
})
app.get(REGEX_URL, function (req, res) {
  	res.render('result',{title: 'URL', url: req.url.substr(5,req.url.length), ip: "0.0.0.0"})
})
app.get('/about', function (req, res) {
	res.render('about',{title: 'About'})
})
app.get('/help', function (req, res) {
	res.render('help',{title: 'Help'})
})
app.get('/test', function (req, res) {
  	res.render('test',{title: 'Test'})
})
app.get('*', function (req,res) {
  	res.render('404',{title: '¿ Qué pasó ?', url : req.headers.host + req.url})
})
app.listen(8888)