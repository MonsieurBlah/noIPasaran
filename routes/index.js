var dnsClass	= require('dns')
  , mongoose 	= require('mongoose')
  , dns_temp	= mongoose.model('dns_temp')
  , dns_final	= mongoose.model('dns_final')
  , user		= mongoose.model('user')
  , flash = require('connect-flash')

var REGEX_IP = /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;

exports.root = function (req, res) {
  	res.render('index',{title: 'Home'})
};

exports.index = function (req, res) {
	res.redirect('/');
}

exports.query = function (req, res) {
	var query = req.body.query;
	if (query.match(REGEX_IP) != null) {
		res.redirect("/ip="+query)
	} else {
		res.redirect("/url="+query)
	};
}

exports.ip = function (req, res) {
	var theIP = req.url.substr(4,req.url.length);
	var theURL = 'www.foo.bar';
	res.render('result',{title: 'IP ' + theIP + ' ', url: theURL, ip: theIP})
};

exports.url = function (req, res) {
	var theURL = req.url.substr(5,req.url.length);

	dnsClass.resolve4(theURL, function(err, addresses){
		if (err) throw err;
		res.render('result',{title: 'URL' + theURL + ' ', url: theURL, ip: addresses})
	})
};

exports.about = function (req, res) {
	res.render('about',{title: 'About'})
};

exports.help = function (req, res) {
	res.render('help',{title: 'Help', message: req.flash('info')})
};

exports.submit = function (req, res) {
	var body = req.body;
	if (body.primaryip.match(REGEX_IP)&&body.secondaryip.match(REGEX_IP)) {
		new dns_temp({
			DNSname 	: req.body.dnsname,
			primaryIP 	: req.body.primaryip,
			secondaryIP : req.body.secondaryip,
			country		: req.body.country,
			isISP		: req.body.isisp,
			updatedAt	: Date.now()
		}).save(function(err, dns_temp, count) {
		if (err) {console.log("Err on save")};
			req.flash('info', 'ok')
			res.redirect('/help');
		})
	} else {
		req.flash('info', 'notok')
		res.redirect('/help');
	};
	
};

exports.destroy = function (req, res) {
	dns_temp.findById(req.params.id, function (err, dnses) {
		dnses.remove( function (err, dnses) {
			res.redirect('/admin');
		})
	})
};

exports.validate = function (req, res) {
	dns_temp.findById(req.params.id, function(err, dns) {
		new dns_final({
		DNSname 	: dns.DNSname,
		primaryIP 	: dns.primaryIP,
		secondaryIP : dns.secondaryIP,
		country		: dns.country,
		isISP		: dns.isISP,
		updatedAt	: Date.now()
	}).save(function(err, dns_final, count) {
		if (err) {"Err on save"};
		dns.remove( function(err, dns) {
			res.redirect('/admin');
		})
	})
	})
};

exports.edit = function (req, res) {
	dns_temp.find( function(err, dnses) {
		if (err) {};
		res.render('admin_edit',{title: 'Admin', dnslist: dnses, current: req.params.id})
	});
};

exports.update = function (req, res) {
	dns_temp.findById(req.params.id, function(err, dns) {
		dns.DNSname		= req.body.dnsname;
		dns.primaryIP 	= req.body.primaryip;
		dns.secondaryIP = req.body.secondaryip;
		dns.country		= req.body.country;
		dns.isISP 		= req.body.isisp;
		dns.updatedAt	= Date.now();
		dns.save(function(err, dns, count) {
			res.redirect('/admin');
		});
	});
};

exports.admin = function (req, res) {
	dns_temp.find( function(err, dnses) {
		if (err) {};
		res.render('admin',{title: 'Admin', dnslist: dnses});
	});
};

exports.test = function (req, res) {
	dns_final.find( function(err, dnses) {
		if (err) {};
		res.render('test',{title: 'Test', dnslist: dnses});
	});
};

exports.fourOfour = function (req, res) {
  	res.render('404',{title: '¿ Qué pasó ?', url : req.headers.host + req.url})
};