var dns 		= require('dns')
  , mongoose 	= require('mongoose')
  , dns_model	= mongoose.model('dns_model')

var REGEX_IP = /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;

exports.root = function (req, res) {
  	res.render('index',{title: 'Home'})
};

exports.index = function (req, res) {
	res.redirect('/');
}

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

exports.submit = function (req, res) {
	console.log("BOUM = " + req.body.toString());
	new dns_model({
		dns_name 	: req.body.dnsname,
		primary_ip 	: req.body.primaryip,
		secondary_ip: req.body.secondaryip,
		is_isp		: req.body.isisp,
		updated_at	: Date.now()
	}).save(function(err, dns, count){
		res.redirect('/help');
	})
};

exports.admin = function (req, res) {
	dns_model.find( function(err, dns, count){
		res.render('admin',{title: 'Admin', dns: dns});
	});
};

exports.test = function (req, res) {
};

exports.fourOfour = function (req, res) {
  	res.render('404',{title: '¿ Qué pasó ?', url : req.headers.host + req.url})
};