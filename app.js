/*
 * Module dependencies
 */
var express = require('express')
  , stylus  = require('stylus')
  , nib     = require('nib')

var app = express()
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
  res.render('index',{title : 'Home'})
})
app.get('/index', function (req, res) {
  res.render('index',{title : 'Home'})
})
app.get('/ip', function (req, res) {
	res.render('ip',{title : 'IP'})
})
app.get('/about', function (req, res) {
	res.render('about',{title : 'About'})
})
app.get('/help', function (req, res) {
	res.render('help',{title : 'Help'})
})
app.get('*', function (req,res) {
  res.render('404',{title : '¿ Qué pasó ?', url : req.headers.host + req.url})
})
app.listen(8888)