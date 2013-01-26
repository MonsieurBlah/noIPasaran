var dns = require('dns')

var REGEX_IP = /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;

exports.index = function (req, res) {
  	res.render('index',{title: 'Home'})
};

exports.ip = function (req, res) {
	var theIP = req.url.substr(4,req.url.length);
	var theURL = 'www.foo.bar';
	res.render('result',{title: 'IP ' + theIP + ' ', url: theURL, ip: theIP})
};

exports.url = function (req, res) {
	var theURL = req.url.substr(5,req.url.length);
	dns.resolve4(theURL, function(err, addresses){
		if (err) throw err;
		res.render('result',{title: 'URL' + theURL + ' ', url: theURL, ip: addresses})
	})
};

exports.about = function (req, res) {
	res.render('about',{title: 'About'})
};

exports.help = function (req, res) {
	res.render('help',{title: 'Help'})
};

exports.test = function (req, res) {
  	res.render('test',{title: 'Test'})
};

exports.fourOfour = function (req, res) {
  	res.render('404',{title: '¿ Qué pasó ?', url : req.headers.host + req.url})
};